__dangerous_query-kill-process() {
  osascript -e 'tell application "System Events" to get name of every process whose background only is false' \
    | tr ',' '\n' | sed 's/^ *//'
}

__action-kill-process() {
  osascript -e "tell application \"$1\" to quit"
}

__omni-fzf-kill-process() {
  local popup="$HOME/bin/omni/popup.sh"
  local selected
  selected=$(__dangerous_query-kill-process | "$popup" "" "$*")
  [[ -n "$selected" ]] && __action-kill-process "$selected"
}
