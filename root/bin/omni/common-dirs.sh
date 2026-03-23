__query-dirs() {
  { zoxide query -l 2>/dev/null; find "$HOME" -maxdepth 3 -type d 2>/dev/null; } | awk '!seen[$0]++'
}

__action-dirs() {
  local POPUP_SESSION="popup"
  local dir="$(echo "$1" | cut -f1)"
  # [[ -d "$dir" ]] && tmux display-popup -E -w 80% -h 70% "yazi '$dir'"
	[[ -d "$dir" ]] && tmux popup -d -xC -yC -w 80% -h 70% -E "tmux new -s ${POPUP_SESSION} -c $dir"
}

__omni-fzf-dirs() {
  local popup="$HOME/bin/omni/popup.sh"
  local selected
  selected=$(__query-dirs | "$popup")
  [[ -n "$selected" ]] && __action-dirs "$selected"
}
alias d='__omni-fzf-dirs'
