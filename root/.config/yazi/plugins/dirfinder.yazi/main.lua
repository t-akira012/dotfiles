local M = {}

-- Keep current cwd in sync
local state = ya.sync(function()
	return tostring(cx.active.current.cwd)
end)

function M:entry()
	local cwd = state()

	local permit = ui.hide()
	local target, err = M.run_with(cwd)
	permit:drop()

	if not target then
		ya.notify({ title = "DirFinder", content = tostring(err), timeout = 5, level = "error" })
	elseif target ~= "" then
		ya.emit("cd", { target, raw = true })
	end
end

function M.fzf_options()
	local opts = {
		"--bind=ctrl-z:ignore,btab:up,tab:down",
		"--cycle",
		"--keep-right",
		"--layout=reverse",
		"--height=100%",
		"--border",
		"--info=inline",
		"--exit-0",
	}

	if ya.target_family() == "unix" then
		opts[#opts + 1] = "--preview-window=down,30%,sharp"
		if ya.target_os() == "linux" then
			opts[#opts + 1] = [[--preview='\command -p ls -Cp --color=always --group-directories-first {}']]
		else
			opts[#opts + 1] = [[--preview='\command -p ls -Cp {}']]
		end
	end

	return table.concat(opts, " ")
end

-- ---------- path helpers ----------

local function strip_file_scheme(s)
	return (s or ""):gsub("^file://", "")
end

local function normalize_path(s)
	s = strip_file_scheme(s)
	if s == "/" then
		return "/"
	end
	return (s or ""):gsub("/+$", "")
end

local function is_descendant_or_same(child, parent)
	if parent == "/" then
		return child:sub(1, 1) == "/"
	end
	return child == parent or child:sub(1, #parent + 1) == (parent .. "/")
end

-- rule:
-- { kind="prefix", path="/a/b" }            -> /a/b and descendants
-- { kind="glob1",  base="/Volumes" }        -> /Volumes/<mount> and descendants (exclude /Volumes)
local function is_allowed_fd_root(cwdp, rule)
	if rule.kind == "prefix" then
		return rule.path ~= "" and is_descendant_or_same(cwdp, rule.path)
	end

	if rule.kind == "glob1" then
		if cwdp == rule.base then
			return false
		end
		return cwdp:match("^" .. rule.base .. "/[^/]+") ~= nil
	end

	return false
end

-- Returns: run_fd (bool), max_depth (number or nil)
local function get_fd_config(cwd)
	local cwdp = normalize_path(cwd)
	local home = normalize_path(os.getenv("HOME") or "")

	if home ~= "" then
		-- cwd is a proper descendant of $HOME → no depth limit
		if cwdp ~= home and is_descendant_or_same(cwdp, home) then
			return true, nil
		end
		-- cwd is $HOME or an ancestor of $HOME → depth 1
		if cwdp == home or is_descendant_or_same(home, cwdp) then
			return true, 1
		end
	end

	-- /Volumes/<mount> and descendants → no depth limit
	if is_allowed_fd_root(cwdp, { kind = "glob1", base = "/Volumes" }) then
		return true, nil
	end

	return false, nil
end

---@param cwd string
---@return string?, Error?
function M.run_with(cwd)
	local run_fd, max_depth = get_fd_config(cwd)

	-- Get directories from fd (restricted)
	local fd_output = ""
	if run_fd then
		local fd_args = { "--type", "d", "--hidden", "--exclude", ".git" }
		if max_depth then
			fd_args[#fd_args + 1] = "--max-depth"
			fd_args[#fd_args + 1] = tostring(max_depth)
		end
		local fd_child =
			Command("fd"):arg(fd_args):cwd(cwd):stdout(Command.PIPED):spawn()

		if fd_child then
			local out = fd_child:wait_with_output()
			if out and out.stdout then
				for line in out.stdout:gmatch("[^\r\n]+") do
					fd_output = fd_output .. cwd .. "/" .. line .. "\n"
				end
			end
		end
	end

	-- Get directories from zoxide
	local zo_child = Command("zoxide"):arg({ "query", "-l", "--exclude", cwd }):stdout(Command.PIPED):spawn()

	local zo_output = ""
	if zo_child then
		local out = zo_child:wait_with_output()
		if out and out.stdout then
			zo_output = out.stdout
		end
	end

	-- Combine both sources
	local combined = fd_output .. zo_output
	if combined == "" then
		return nil, Err("No directories found")
	end

	-- Run fzf
	local child, err =
		Command("fzf"):env("FZF_DEFAULT_OPTS", M.fzf_options()):stdin(Command.PIPED):stdout(Command.PIPED):spawn()

	if not child then
		return nil, Err("Failed to start `fzf`, error: %s", err)
	end

	child:write_all(combined)
	child:flush()

	local output, err = child:wait_with_output()
	if not output then
		return nil, Err("Cannot read `fzf` output, error: %s", err)
	elseif not output.status.success and output.status.code ~= 130 then
		return nil, Err("`fzf` exited with code %s", output.status.code)
	end

	return output.stdout:gsub("\n$", ""), nil
end

return M
