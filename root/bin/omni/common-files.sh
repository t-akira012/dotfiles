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

# TODO: ctrl-oでディレクトリをpopupで開く
__action-files() {
  local file="$(echo "$1" | cut -f1)"
  [[ -f "$file" ]] && open "$file"
}

__omni-fzf-files() {
  local popup="$HOME/bin/omni/popup.sh"
  local selected
  selected=$(__query-files | "$popup" "--query=$*")
  [[ -n "$selected" ]] && __action-files "$selected"
}
alias f='__omni-fzf-files'
