#!/bin/bash

# 現在のセッション名を取得
CURRENT_SESSION=$(tmux display-message -p -F "#{session_name}")
if [[ "$CURRENT_SESSION" == "term_on_vim"* ]] ; then
	exit 0
fi


if [[ $(whoami) != "t-akira012" ]] && [[  $(whoami) != "aki" ]]; then
	exit 0
fi

# POPセッション名
POPUP_SESSION="ssh-prv"
SSH_CMD=aki@prv

create() {
	# ウィンドウのサイズを設定
	local width='96%'
	local height='100%'

	# セッション名に"popup"が含まれるかチェック
	if [[ $CURRENT_SESSION == *"${POPUP_SESSION}"* ]]; then
		# popupセッションなら、クライアントをデタッチ（ポップアップを閉じる）
		tmux detach-client
	else
		# popupセッションでないなら、新しいポップアップウィンドウを表示
		tmux popup -d '#{pane_current_path}' -xC -yC -w$width -h$height -E "ssh ${SSH_CMD} -t tmux attach-session -t ${POPUP_SESSION} || ssh ${SSH_CMD} -t tmux new -s ${POPUP_SESSION}"
	fi
}

create
