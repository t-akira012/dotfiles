from keyhac import LaunchApplication


def configure(keymap):
    keymap.editor = "notepad.exe"

    global_keys = keymap.define_keytable(focus_path_pattern="*")
    # Mark left Win as used before releasing it so a lone press does not open Start.
    global_keys["U-LWin"] = "D-LCtrl", "U-LCtrl", "U-LWin"

    def toggle_windows_terminal():
        active = keymap.get_active_window()
        if active and active.app_name.lower() == "windowsterminal":
            active.minimize()
            return

        terminal = keymap.find_window(app="WindowsTerminal")
        if terminal:
            if terminal.is_minimized():
                terminal.restore()
            terminal.activate()
        else:
            LaunchApplication("wt.exe")()

    global_keys["Alt-Semicolon"] = toggle_windows_terminal
    global_keys["Win-Tab"] = lambda: None
    global_keys["Win-V"] = lambda: None
    # Windows intercepts Win+L before Keyhac's hook; this binding cannot stop locking.
    global_keys["Win-L"] = lambda: None

    def emacs_keybinds(table):
        table["LCtrl-P"] = "Up"
        table["LCtrl-N"] = "Down"
        table["LCtrl-F"] = "Right"
        table["LCtrl-B"] = "Left"
        table["LCtrl-A"] = "Home"
        table["LCtrl-E"] = "End"
        table["LCtrl-H"] = "Back"
        table["LCtrl-D"] = "Delete"
        table["LCtrl-K"] = "Shift-End", "Back"

    emacs_keybinds(
        keymap.define_keytable(
            app="msedge|msedgewebview2|chrome|hidemaru|notepad|PowerToys.PowerLauncher"
        )
    )
    emacs_keybinds(
        keymap.define_keytable(
            custom_condition_func=lambda focus: (
                focus.app_name.lower() == "cmd"
                and "nvim" not in (focus.window_title or "").lower()
            )
        )
    )
