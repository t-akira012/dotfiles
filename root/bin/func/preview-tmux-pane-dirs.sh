#!/bin/bash
# preview-tmux-window.sh - show pane directories in a tmux window
win_index=$(echo "$1" | cut -d: -f1)
tmux list-panes -t "$win_index" -F '#{pane_current_path}'
