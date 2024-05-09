-- ln -si $PWD/.wezterm.lua $HOME/.wezterm.lua
local wezterm = require 'wezterm'
local config = {}
config.window_decorations = 'RESIZE'
config.font = wezterm.font 'JetBrains Mono'
config.keys = {
    {
        key = 'w',
        mods = 'CMD',
        action = wezterm.action.DisableDefaultAssignment,

    },
    {
        key = 'm',
        mods = 'CMD',
        action = wezterm.action.DisableDefaultAssignment,

    },
}
return config
