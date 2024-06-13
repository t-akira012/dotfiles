#!/bin/bash

VIM_PID=$1

# 現在のセッション名を取得
CURRENT_SESSION=$(tmux display-message -p -F "#{session_name}")

# POPセッション名
POPUP_SESSION="term_on_vim${VIM_PID}"

# tmux popup windowをトグルする関数
max() {
	# ウィンドウのサイズを設定
	local width='100%'
	local height='100%'

	# セッション名に"popup"が含まれるかチェック
	if [[ $CURRENT_SESSION == *"${POPUP_SESSION}"* ]]; then
		# "popup"が含まれる場合、クライアントをデタッチ（ポップアップを閉じる）
		tmux detach-client
	else
		# "popup"が含まれない場合、新しいポップアップウィンドウを表示
		tmux popup -d '#{pane_current_path}' -xC -yC -w$width -h$height -E "tmux attach -t ${POPUP_SESSION} || tmux new -s ${POPUP_SESSION}"
	fi
}

right() {
	local width='50%'
	local height='100%'

	if [[ $CURRENT_SESSION == *"${POPUP_SESSION}"* ]]; then
		tmux detach-client
	else
		tmux popup -d '#{pane_current_path}' -xR -yC -w$width -h$height -E "tmux attach -t ${POPUP_SESSION} || tmux new -s ${POPUP_SESSION}"
	fi
}

bottom() {
	local width='100%'
	local height='60%'

	if [[ $CURRENT_SESSION == *"${POPUP_SESSION}"* ]]; then
		tmux detach-client
	else
		tmux popup -d '#{pane_current_path}' -xC -y60 -w$width -h$height -E "tmux attach -t ${POPUP_SESSION} || tmux new -s ${POPUP_SESSION}"
	fi
}

if [[ "$1" == "right" ]]; then
	right &
elif [[ "$1" == "max" ]]; then
	max &
elif [[ "$1" == "bottom" ]]; then
	bottom &
else
	bottom &
fi
