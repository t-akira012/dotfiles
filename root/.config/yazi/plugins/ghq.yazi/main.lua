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
			opts[#opts + 1] = [[--preview='\command -p cat {}/README.md']]
		else
			opts[#opts + 1] = [[--preview='\command -p cat {}/README.md']]
		end
	end

	return table.concat(opts, " ")
end

---@param cwd string
---@return string?, Error?
function M.run_with(cwd)
	-- Get directories from ghq
	-- Use `ghq list -p` to get full paths
	local ghq_child = Command("ghq"):arg({ "list", "-p" }):stdout(Command.PIPED):spawn()

	local ghq_output = ""
	if ghq_child then
		local out = ghq_child:wait_with_output()
		if out and out.stdout then
			ghq_output = out.stdout
		end
	end

	if ghq_output == "" then
		return nil, Err("No directories found (failed to get output from `ghq list -p`)")
	end

	-- Run fzf with ghq input
	local child, err =
		Command("fzf"):env("FZF_DEFAULT_OPTS", M.fzf_options()):stdin(Command.PIPED):stdout(Command.PIPED):spawn()

	if not child then
		return nil, Err("Failed to start `fzf`, error: %s", err)
	end

	child:write_all(ghq_output)
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
