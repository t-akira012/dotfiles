__query-tmux-windows() {
  tmux list-windows -F '#{window_index}: #{window_name}'
}

__action-tmux-windows() {
  tmux select-window -t "${1%%:*}"
}

__omni-fzf-tmux-select-window() {
  local popup="$HOME/bin/omni/popup.sh"
  local selected
  selected=$(__query-tmux-windows | "$popup" "--query=$*")
  [[ -n "$selected" ]] && __action-tmux-windows "$selected"
}
alias tw='__omni-fzf-tmux-select-window'
