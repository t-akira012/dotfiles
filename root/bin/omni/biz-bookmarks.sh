__action-bookmarks() {
  open "$(echo "$1" | cut -f1)"
}

__action-history() {
  open "$(echo "$1" | cut -f1)"
}

__query-bookmarks() {
  local chrome_dir="$HOME/Library/Application Support/Google/Chrome"
  for file in "$chrome_dir"/Profile\ */Bookmarks; do
    [[ -e "$file" ]] && jq -r '.. | select(.type? == "url") | "\(.url)\t\(.name)"' "$file"
  done
}

__query-history() {
  local chrome_dir="$HOME/Library/Application Support/Google/Chrome"
  local dbs=("${(@f)$(find "$chrome_dir" -name "History" -path "*/Profile */History" 2>/dev/null)}")
  [[ ${#dbs[@]} -eq 0 ]] && return 1
  local tmp=$(mktemp)
  {
    for db in "${dbs[@]}"; do
      command cp "$db" "$tmp"
      sqlite3 "$tmp" "SELECT url, title FROM urls ORDER BY last_visit_time DESC LIMIT 5000;" -separator $'\t'
    done
  } | awk -F'\t' '!seen[$1]++'
  rm -f "$tmp"
}

__omni-fzf-open-url() {
  local popup="$HOME/bin/omni/popup.sh"
  local tmp_data=$(mktemp)
  cat > "$tmp_data"
  local selected
  selected=$(awk -F'\t' '{printf "%-40.40s  %.70s\n", $1, $2}' "$tmp_data" | "$popup")
  if [[ -n "$selected" ]]; then
    local line=$(grep -nF "$selected" <(awk -F'\t' '{printf "%-40.40s  %.70s\n", $1, $2}' "$tmp_data") | head -1 | cut -d: -f1)
    local url=$(sed -n "${line}p" "$tmp_data" | cut -f1)
    open "$url"
  fi
  rm -f "$tmp_data"
}

__omni-fzf-bookmarks() { __query-bookmarks | __omni-fzf-open-url; }
__omni-fzf-chrome-history() { __query-history | __omni-fzf-open-url; }
__omni-fzf-bookmarks-and-history() { { __query-bookmarks; __query-history; } | __omni-fzf-open-url; }

alias b='__omni-fzf-bookmarks-and-history'
alias t='__omni-fzf-todo'
