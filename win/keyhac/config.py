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

    # LWin単発押下を無効化（スタートメニュー抑止）
    keymap_global = keymap.defineWindowKeymap()
    keymap_global["O-LWin"] = lambda: None

    # Emacs keybindings (whitelist)
    target_apps = ["msedgewebview2.exe", "chrome.exe", "notepad.exe"]

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

    # cmd.exe: Nvimがタイトルに含まれる場合は除外
    emacs_keybinds(keymap.defineWindowKeymap(
        check_func=lambda w: w.getProcessName() == "cmd.exe" and "Nvim" not in w.getText()
    ))
