#!/bin/bash
# fzf-tmux-window.sh - select tmux window via fzf popup
popup="$HOME/bin/func/fzf-tmux-popup.sh"
win=$(tmux list-windows -F '#{window_index}: #{window_name}' \
  | "$popup" "$HOME/bin/func/preview-tmux-pane-dirs.sh {}")
[[ -n "$win" ]] && tmux select-window -t "${win%%:*}"
