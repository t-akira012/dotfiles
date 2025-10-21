#!/bin/bash

set -eux

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
		local HOST_PRIMARY="prv"
		local HOST_FALLBACK="vpn"
		local SSH_USER="aki"

		# ウィンドウのサイズを設定
		local width='96%'
		local height='100%'

		# セッション名に"popup"が含まれるかチェック
		if [[ $CURRENT_SESSION == *"${POPUP_SESSION}"* ]]; then
				# popupセッションなら、クライアントをデタッチ(ポップアップを閉じる)
				tmux detach-client
		else
				# pingで疎通確認(1秒でタイムアウト、1回のみ試行)
				local SSH_HOST
				if ping -c 1 -W 1 ${HOST_PRIMARY} >/dev/null 2>&1; then
						SSH_HOST="${HOST_PRIMARY}"
				else
						SSH_HOST="${HOST_FALLBACK}"
				fi

				local SSH_CMD="${SSH_USER}@${SSH_HOST}"

				# popupセッションでないなら、新しいポップアップウィンドウを表示
				tmux popup -d '#{pane_current_path}' -xC -yC -w$width -h$height -E \
						"ssh ${SSH_CMD} -t tmux attach-session -t ${POPUP_SESSION} 2>/dev/null || \
						 ssh ${SSH_CMD} -t tmux new -s ${POPUP_SESSION}"
		fi
}


if [[ $(whoami) != "t-akira012" ]] && [[  $(whoami) != "aki" ]]; then
	create_agent_popup_window
else
	create_ssh_popup_window
fi
