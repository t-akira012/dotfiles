--- @async

local home = os.getenv("HOME") or ""

local function short(s)
	return tostring(s):gsub("^" .. home, "~")
end

local function basename(s)
	return tostring(s):match("[^/]+$") or tostring(s)
end

local function dirname(s)
	return tostring(s):match("^(.+)/[^/]+$") or tostring(s)
end

local get_data = ya.sync(function()
	local dest = tostring(cx.active.current.cwd)
	local is_cut = cx.yanked.is_cut
	local paths = {}
	for _, url in pairs(cx.yanked) do
		paths[#paths + 1] = tostring(url)
	end
	return { dest = dest, paths = paths, is_cut = is_cut }
end)

local function entry()
	local d = get_data()
	if #d.paths == 0 then return end

	local lines = {}
	for _, p in ipairs(d.paths) do
		lines[#lines + 1] = "src:  " .. short(dirname(p))
			.. "\ndest: " .. short(d.dest)
			.. "\nfile: " .. basename(p)
	end

	local op = d.is_cut and "Move" or "Copy"
	local confirmed = ya.confirm {
		pos   = { "center", w = 60, h = 10 },
		title = op .. "?",
		body  = table.concat(lines, "\n---\n"),
	}

	if confirmed then
		ya.emit("paste", {})
	end
end

return { entry = entry }
