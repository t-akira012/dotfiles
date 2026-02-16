import datetime
import os
import sys

import pyauto

from keyhac import *


def configure(keymap):
    if 1:
        keymap.editor = "notepad.exe"
    if 0:

        def editor(path):
            shellExecute(None, "notepad.exe", '"%s"' % path, "")

        keymap.editor = editor

    # --------------------------------------------------------------------
    # Customizing the display

    # Font
    keymap.setFont("MS Gothic", 12)

    # Theme
    keymap.setTheme("black")

    # --------------------------------------------------------------------

    # Simple key replacement
    # keymap.replaceKey("LWin", 235)
    # keymap.replaceKey("RWin", 255)

    # Emacs keybindings (whitelist)
    target_apps = ["ms-teams.exe", "chrome.exe", "notepad.exe"]

    def emacs_keybinds(km):
        km["LC-P"] = "Up"
        km["LC-N"] = "Down"
        km["LC-F"] = "Right"
        km["LC-B"] = "Left"
        km["LC-A"] = "Home"
        km["LC-E"] = "End"
        km["LC-H"] = "Back"
        km["LC-D"] = "Delete"
        km["LC-K"] = "S-End", "Back"

    for app in target_apps:
        emacs_keybinds(keymap.defineWindowKeymap(exe_name=app))
