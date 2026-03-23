# data sources: output "url\ttitle" lines
__query-bookmarks() {
  local file="$HOME/src/github.com/t-akira012/prv/README.md"
  [[ -e "$file" ]] && sed -n 's/.*\[\([^]]*\)\](\([^)]*\)).*/\2\t\1/p' "$file"
}

__query-history() {
  local profile_dir="$HOME/Library/Application Support/zen/Profiles"
  local dbs=("${(@f)$(find "$profile_dir" -name "places.sqlite" 2>/dev/null)}")
  [[ ${#dbs[@]} -eq 0 ]] && return 1
  local tmp=$(mktemp)
  {
    for db in "${dbs[@]}"; do
      command cp "$db" "$tmp"
      sqlite3 "$tmp" "SELECT p.url, p.title FROM moz_places p INNER JOIN moz_historyvisits v ON p.id = v.place_id ORDER BY v.visit_date DESC LIMIT 5000;" -separator $'\t'
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
__fzf-firefox-history() { __query-history | __fzf-open-url; }
__fzf-bookmarks-and-history() { { __query-bookmarks; __query-history; } | __fzf-open-url; }

# alias h='__fzf-firefox-history'
# alias b='__fzf-bookmarks'
alias b='__fzf-bookmarks-and-history'
