PROJECT_MD="$HOME/docs/doc/DRAFT.md"

__fzf-projects() {
  [[ -z "$EDITOR" ]] && { echo "EDITOR is not set" >&2; return 1; }

  local popup="$HOME/bin/func/fzf-tmux-popup.sh"
  local selected
  selected="$([[ -f "$PROJECT_MD" ]] && grep -n '^#' "$PROJECT_MD" | "$popup")"

  [[ -z "$selected" ]] && return

  local line_num="${selected%%:*}"
  if ! tmux select-window -t :9 2>/dev/null; then
    tmux new-window -t :9 -n doc
    tmux send-keys -t :9 "$EDITOR +${line_num} ${PROJECT_MD}" Enter
  elif [[ "$(tmux list-panes -t :9 -F '#{pane_current_command}')" == "nvim" ]]; then
    tmux send-keys -t :9 ":tabnew +${line_num} ${PROJECT_MD}" Enter
  else
    tmux send-keys -t :9 "$EDITOR +${line_num} ${PROJECT_MD}" Enter
  fi
}

alias p='__fzf-projects'
