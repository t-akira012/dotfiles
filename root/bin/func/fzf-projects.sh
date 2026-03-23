PROJECT_MD="$HOME/docs/doc/omnipj.md"

__fzf-projects() {
  local popup="$HOME/bin/func/fzf-tmux-popup.sh"
  local selected
  selected="$([[ -f "$PROJECT_MD" ]] && grep -n '^#' "$PROJECT_MD" | "$popup")"

  [[ -z "$selected" ]] && return

  local line_num="${selected%%:*}"
  "${EDITOR:-vim}" +"$line_num" "$PROJECT_MD"
}

alias p='__fzf-projects'
