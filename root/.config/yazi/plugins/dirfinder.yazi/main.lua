local M = {}

local state = ya.sync(function()
	return tostring(cx.active.current.cwd)
end)

function M:entry()
	local cwd = state()

	local permit = ui.hide()
	local target, err = M.run_with(cwd)
	permit:drop()

	if not target then
		ya.notify { title = "DirFinder", content = tostring(err), timeout = 5, level = "error" }
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

---@param cwd string
---@return string?, Error?
function M.run_with(cwd)
	-- Get directories from fd
	local fd_child = Command("fd")
		:arg({ "--type", "d", "--hidden", "--exclude", ".git" })
		:cwd(cwd)
		:stdout(Command.PIPED)
		:spawn()

	local fd_output = ""
	if fd_child then
		local out = fd_child:wait_with_output()
		if out and out.stdout then
			for line in out.stdout:gmatch("[^\r\n]+") do
				fd_output = fd_output .. cwd .. "/" .. line .. "\n"
			end
		end
	end

	-- Get directories from zoxide
	local zo_child = Command("zoxide")
		:arg({ "query", "-l", "--exclude", cwd })
		:stdout(Command.PIPED)
		:spawn()

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

	-- Run fzf with combined input
	local child, err = Command("fzf")
		:env("FZF_DEFAULT_OPTS", M.fzf_options())
		:stdin(Command.PIPED)
		:stdout(Command.PIPED)
		:spawn()

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
