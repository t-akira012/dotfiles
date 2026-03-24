__manual_query-dirs() {
  { zoxide query -l 2>/dev/null } | awk '!seen[$0]++'
}

__action-dirs() {
  local POPUP_SESSION="popup"
  local dir="$(echo "$1" | cut -f1)"
  # [[ -d "$dir" ]] && tmux display-popup -E -w 80% -h 70% "yazi '$dir'"

  # 既存 session がある場合でも毎回 $dir で新しい window を 1 枚作って、そこを前面にして popup 内で attach
  if [[ -d "$dir" ]]; then
    tmux popup -d -xC -yC -w 80% -h 70% -E "bash -lc '
      if tmux has-session -t \"${POPUP_SESSION}\" 2>/dev/null; then
        win_id=\$(tmux new-window -P -F \"#{window_id}\" -t \"${POPUP_SESSION}:\" -c \"\$1\")
        tmux select-window -t \"\$win_id\"
        exec tmux attach-session -t \"${POPUP_SESSION}\"
      else
        exec tmux new-session -s \"${POPUP_SESSION}\" -c \"\$1\"
      fi
    ' bash '$dir'"
  fi
}

__omni-fzf-dirs() {
  local popup="$HOME/bin/omni/popup.sh"
  local selected
  selected=$(__manual_query-dirs | "$popup" "" "$*")
  [[ -n "$selected" ]] && __action-dirs "$selected"
}
alias d='__omni-fzf-dirs'
