__query-files() {
  local ext_args=()
  local dir

  for ext in "${INCLUDE_EXTS[@]}"; do
    ext_args+=(-e "$ext")
  done

  for dir in "${FIND_FILE_DIRS[@]}"; do
    [[ -d "$dir" ]] || continue
    fd --max-depth 3 --type f "${ext_args[@]}" . "$dir" 2>/dev/null
  done | awk '!seen[$0]++'
}

__action-files() {
  local file="$(echo "$1" | cut -f1)"
  [[ -f "$file" ]] && open "$file"
}

__action-files-open-dir() {
  local file="$(echo "$1" | cut -f1)"
  local dir="${file%/*}"
  local POPUP_SESSION="popup"
  [[ -d "$dir" ]] || return
  tmux popup -d -xC -yC -w 80% -h 70% -E "bash -lc '
    if tmux has-session -t \"${POPUP_SESSION}\" 2>/dev/null; then
      win_id=\$(tmux new-window -P -F \"#{window_id}\" -t \"${POPUP_SESSION}:\" -c \"\$1\")
      tmux send-keys -t \"\$win_id\" \"yazi\" Enter
      tmux select-window -t \"\$win_id\"
      exec tmux attach-session -t \"${POPUP_SESSION}\"
    else
      tmux new-session -d -s \"${POPUP_SESSION}\" -c \"\$1\"
      tmux send-keys -t \"${POPUP_SESSION}\" \"yazi\" Enter
      exec tmux attach-session -t \"${POPUP_SESSION}\"
    fi
  ' bash '$dir'"
}

__omni-fzf-files() {
  local popup="$HOME/bin/omni/popup.sh"
  local result key selected
  result=$(__query-files | "$popup" "--expect=ctrl-o --query=$*")
  key=$(echo "$result" | head -1)
  selected=$(echo "$result" | tail -1)
  [[ -z "$selected" ]] && return
  if [[ "$key" == "ctrl-o" ]]; then
    __action-files-open-dir "$selected"
  else
    __action-files "$selected"
  fi
}
alias f='__omni-fzf-files'
