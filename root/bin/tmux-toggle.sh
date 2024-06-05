#!/usr/bin/env bash

CURRENT_SESSION=$(tmux display-message -p -F "#{session_name}")

if [[ "$CURRENT_SESSION" == "term_on_vim" ]]; then
	$HOME/bin/tmux-popup.sh
else
	$HOME/bin/tmux-toggle-window.sh
fi
