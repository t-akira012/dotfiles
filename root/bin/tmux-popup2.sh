#!/bin/bash

# 現在のセッション名を取得
CURRENT_SESSION=$(tmux display-message -p -F "#{session_name}")
if [[ "$CURRENT_SESSION" == "term_on_vim"* ]] ; then
	exit 0
fi

# POPセッション名
POPUP_SESSION="claude-code"

create() {
	# ウィンドウのサイズを設定
	local width='96%'
	local height='100%'

	# セッション名に"popup"が含まれるかチェック
	if [[ $CURRENT_SESSION == *"${POPUP_SESSION}"* ]]; then
		# "popup"が含まれる場合、クライアントをデタッチ（ポップアップを閉じる）
		tmux detach-client
	else
		# "popup"が含まれない場合、新しいポップアップウィンドウを表示
		tmux popup -d '#{pane_current_path}' -xC -yC -w$width -h$height -E "tmux attach -t ${POPUP_SESSION} || tmux new -s ${POPUP_SESSION} -c $HOME/ccc/"
	fi
}

create
