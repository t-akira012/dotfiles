#!/bin/bash

# 現在のセッション名を取得
CURRENT_SESSION=$(tmux display-message -p -F "#{session_name}")
if [[ "$CURRENT_SESSION" == "term_on_vim"* ]] ; then
	exit 0
fi

create_agent_popup_window() {
	# POPセッション名
	local POPUP_SESSION="vibe_coding"

	# ウィンドウのサイズを設定
	local width='96%'
	local height='100%'

	# セッション名に"popup"が含まれるかチェック
	if [[ $CURRENT_SESSION == *"${POPUP_SESSION}"* ]]; then
		# popupセッションなら、クライアントをデタッチ（ポップアップを閉じる）
		tmux detach-client
	else
		# popupセッションでないなら、新しいポップアップウィンドウを表示
		tmux popup -d '#{pane_current_path}' -xC -yC -w$width -h$height -E "tmux attach-session -t ${POPUP_SESSION} || tmux new -s ${POPUP_SESSION} -c '$HOME/dev'"
	fi
}

create_ssh_popup_window() {

	# POPセッション名
	local POPUP_SESSION="ssh-prv"
	local SSH_CMD=aki@prv

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


if [[ $(whoami) != "t-akira012" ]] && [[  $(whoami) != "aki" ]]; then
	create_agent_popup_window
else
	create_ssh_popup_window
fi
