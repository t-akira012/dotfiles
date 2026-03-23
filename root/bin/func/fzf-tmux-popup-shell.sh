#!/bin/bash
# fzf-tmux-popup-shell.sh - run a single shell command via tmux popup input
popup="$HOME/bin/func/fzf-tmux-popup.sh"
cmd=$("$popup" --input "Shell: ")
[[ -z "$cmd" ]] && exit 0
if ! zsh -c "command -v ${cmd%% *}" >/dev/null 2>&1; then
  cmd="__fzf-search $cmd"
fi
zsh -ic "$cmd"
exit 0
