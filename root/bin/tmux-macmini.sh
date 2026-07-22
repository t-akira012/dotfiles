#!/bin/bash

set -eux

CURRENT_SESSION=$(tmux display-message -p -F '#{session_name}')
CURRENT_HOST=$(hostname -s)

if [[ "$CURRENT_SESSION" == term_on_vim* ]]; then
	exit 0
fi

create_agent_popup_window() {
	local POPUP_SESSION='vibe_coding'

	if [[ "$CURRENT_SESSION" == *"$POPUP_SESSION"* ]]; then
		tmux detach-client
	else
		tmux popup \
			-d '#{pane_current_path}' \
			-xC \
			-yC \
			-w '96%' \
			-h '100%' \
			-E \
			"tmux new-session -A -s '$POPUP_SESSION' -c '$HOME/dev'"
	fi
}

create_ssh_popup_window() {
	local REMOTE_SESSION='ssh-mini'
	local HOST_PRIMARY_IP='192.168.52.100'
	local SSH_HOST

	if ping -c 1 -W 1 "$HOST_PRIMARY_IP" >/dev/null 2>&1; then
		SSH_HOST='mini'
	else
		SSH_HOST='vpn'
	fi

	tmux popup \
		-d '#{pane_current_path}' \
		-xC \
		-yC \
		-w '96%' \
		-h '100%' \
		-E \
		"ssh -tt '$SSH_HOST' 'PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin tmux new-session -A -s $REMOTE_SESSION' || {
			status=\$?
			echo
			echo \"SSHまたはtmuxの起動に失敗しました: \$status\"
			echo 'Enterキーで閉じます'
			read
			exit \$status
		}"
}

case "$CURRENT_HOST" in
	m1mbp-prv)
		create_ssh_popup_window
		;;
	m4mini-prv)
		tmux detach-client
		;;
	*)
		echo "Unsupported host: $CURRENT_HOST" >&2
		exit 1
		;;
esac
