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

    exclude_global_target = ["Ubuntu.exe"]

    # Global keymap which affects any windows
    if 1:
        keymap_global = keymap.defineWindowKeymap(check_func=lambda window: not window.getProcessName() in exclude_global_target)

        # emacs like
        keymap_global["LC-P"] = "Up"
        keymap_global["LC-N"] = "Down"
        keymap_global["LC-F"] = "Right"
        keymap_global["LC-B"] = "Left"
        keymap_global["LC-A"] = "Home"
        keymap_global["LC-E"] = "End"
        keymap_global["LC-H"] = "Back"
        keymap_global["LC-D"] = "Delete"
        keymap_global["LC-K"] = "S-End", "Back"
