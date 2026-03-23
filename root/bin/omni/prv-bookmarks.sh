__action-bookmarks() {
  open "$(echo "$1" | cut -f5)"
}

__action-history() {
  open "$(echo "$1" | cut -f5)"
}

__query-bookmarks() {
  local file="$HOME/src/github.com/t-akira012/prv/README.md"
  [[ -e "$file" ]] && sed -n 's/.*\[\([^]]*\)\](\([^)]*\)).*/\2\t\1\t\t\t\2/p' "$file"
}

__query-history() {
  local profile_dir="$HOME/Library/Application Support/zen/Profiles"
  local dbs=("${(@f)$(find "$profile_dir" -name "places.sqlite" 2>/dev/null)}")
  [[ ${#dbs[@]} -eq 0 ]] && return 1
  local tmp=$(mktemp)
  {
    for db in "${dbs[@]}"; do
      command cp "$db" "$tmp"
      sqlite3 "$tmp" "SELECT p.url || char(9) || p.title || char(9) || char(9) || char(9) || p.url FROM moz_places p INNER JOIN moz_historyvisits v ON p.id = v.place_id ORDER BY v.visit_date DESC LIMIT 5000;" -separator $'\t'
    done
  } | awk -F'\t' '!seen[$5]++'
  rm -f "$tmp"
}

__omni-fzf-open-url() {
  local popup="$HOME/bin/omni/popup.sh"
  local fzf_opts="--with-nth=1..4 --delimiter=$'\t'"
  local selected
  selected=$(cat | "$popup" $fzf_opts)
  [[ -n "$selected" ]] && open "$(echo "$selected" | cut -f5)"
}

__omni-fzf-bookmarks() { __query-bookmarks | __omni-fzf-open-url; }
__omni-fzf-zen-history() { __query-history | __omni-fzf-open-url; }
__omni-fzf-bookmarks-and-history() { { __query-bookmarks; __query-history; } | __omni-fzf-open-url; }

alias b='__omni-fzf-bookmarks-and-history'
