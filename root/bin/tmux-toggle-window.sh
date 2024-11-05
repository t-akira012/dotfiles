#!/usr/bin/env bash
set -eux
CURRENT_WINDOW=$(tmux display-message -p '#I')
TARGET_WINDOW=9

[[ ! -e $HOME/.tmux_toggle_window ]] && echo $CURRENT_WINDOW >$HOME/.tmux_toggle_window

if [[ $TARGET_WINDOW -ne $CURRENT_WINDOW ]]; then
	echo $CURRENT_WINDOW >$HOME/.tmux_toggle_window

	if tmux list-windows -F '#I' | rg 9 >/dev/null 2>&1; then
		tmux select-window -t $TARGET_WINDOW
	else
		tmux new-window -n "doc" -t 9
	fi
else
	LATEST_WINDOW=$(cat $HOME/.tmux_toggle_window)
  # 前回のWindowの存在チェック
  if tmux list-windows -F "#{window_index}" | rg -e "^${LATEST_WINDOW}$" > /dev/null 2>&1 ;then
    # 前回のWindowに移動
    tmux select-window -t $LATEST_WINDOW > /dev/null 2>&1
  else
    # 最初のWindowに遷移
    tmux select-window -t $(tmux list-windows -F "#{window_index}" | head -n 1)
  fi
fi
