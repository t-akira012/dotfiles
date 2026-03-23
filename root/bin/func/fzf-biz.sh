# source functions
for f in "$HOME/bin/func"/fzf-biz-*.sh; do
  [[ -e "$f" ]] && source "$f"
done

# data sources: output "url\ttitle" lines
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

# select and open: takes "url\ttitle" from stdin
__fzf-open-url() {
  local popup="$HOME/bin/func/fzf-tmux-popup.sh"
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

__fzf-bookmarks() { __query-bookmarks | __fzf-open-url; }
__fzf-chrome-history() { __query-history | __fzf-open-url; }
__fzf-bookmarks-and-history() { { __query-bookmarks; __query-history; } | __fzf-open-url; }

# alias h='__fzf-chrome-history'
# alias b='__fzf-bookmarks'
alias b='__fzf-bookmarks-and-history'
