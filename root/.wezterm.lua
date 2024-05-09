-- ln -si $PWD/.wezterm.lua $HOME/.wezterm.lua
local wezterm = require 'wezterm'
local config = {}
config.window_decorations = 'RESIZE'
config.hide_tab_bar_if_only_one_tab = true
config.font = wezterm.font 'Cica'
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
