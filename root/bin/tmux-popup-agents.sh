#!/usr/bin/env bash
# .tmux.conf
# bind -n C-] run-shell "$HOME/bin/tmux-popup-agents.sh"
set -eu

POPUP_SESSION='agents'

ensure_session() {
	if tmux has-session -t "${POPUP_SESSION}" 2>/dev/null; then
		return
	fi
	tmux new-session -d -s "${POPUP_SESSION}" -c "${HOME}/dev" -n agent-1
	tmux new-window -t "${POPUP_SESSION}" -c "${HOME}/dev" -n agent-2
	tmux new-window -t "${POPUP_SESSION}" -c "${HOME}/dev" -n haiku
	tmux new-window -t "${POPUP_SESSION}" -c "${HOME}/dev" -n eiyaku
	tmux select-window -t "${POPUP_SESSION}:agent-1"
}

toggle() {
	local current_session
	current_session=$(tmux display-message -p -F "#{session_name}")

	if [[ "${current_session}" == "${POPUP_SESSION}" ]]; then
		tmux detach-client
	else
		ensure_session
		tmux popup -d "${HOME}/dev" -xC -yC -w50% -h90% \
			-E "tmux attach -t ${POPUP_SESSION}"
	fi
}

main() {
	toggle &
}

main
