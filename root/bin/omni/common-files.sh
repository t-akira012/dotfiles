__query-files() {
  local ext_args=()
  for ext in "${INCLUDE_EXTS[@]}"; do
    ext_args+=(-e "$ext")
  done
  { zoxide query -l 2>/dev/null; find "$HOME" -maxdepth 3 -type d 2>/dev/null; } \
    | awk '!seen[$0]++' \
    | while read -r dir; do
        fd --max-depth 3 --type f "${ext_args[@]}" . "$dir" 2>/dev/null
      done | awk '!seen[$0]++'
}

__action-files() {
  local file="$(echo "$1" | cut -f1)"
  [[ -f "$file" ]] && open "$file"
}

__omni-fzf-files() {
  local popup="$HOME/bin/omni/popup.sh"
  local selected
  selected=$(__query-files | "$popup")
  [[ -n "$selected" ]] && __action-files "$selected"
}
alias f='__omni-fzf-files'
