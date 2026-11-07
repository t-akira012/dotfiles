from keyhac import LaunchApplication


def configure(keymap):
    keymap.editor = "notepad.exe"

    global_keys = keymap.define_keytable(focus_path_pattern="*")
    global_keys["O-LWin"] = lambda: None

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

    global_keys["Win-Semicolon"] = toggle_windows_terminal
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
            app="msedgewebview2|chrome|notepad|PowerToys.PowerLauncher"
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
