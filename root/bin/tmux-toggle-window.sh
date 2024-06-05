#!/usr/bin/env bash
set -eux
CURRENT_WINDOW=$(tmux display-message -p '#I')
TARGET_WINDOW=9

[[ ! -e $HOME/.tmux_toggle_window ]] && echo $CURRENT_WINDOW >$HOME/.tmux_toggle_window

if [[ $TARGET_WINDOW -ne $CURRENT_WINDOW ]]; then
	echo $CURRENT_WINDOW >$HOME/.tmux_toggle_window

	if tmux list-windows -F '#I' | rg 9 >/dev/null &>1; then
		tmux select-window -t $TARGET_WINDOW
	else
		tmux new-window -n "doc" -t 9
	fi
else
	LATEST_WINDOW=$(cat $HOME/.tmux_toggle_window)
	tmux select-window -t $LATEST_WINDOW
fi
