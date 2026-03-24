__action-bookmarks() {
  open "$(echo "$1" | awk -F'\t' '{print $NF}')"
}

__action-history() {
  open "$(echo "$1" | awk -F'\t' '{print $NF}')"
}

__query-bookmarks() {
  local chrome_dir="$HOME/Library/Application Support/Google/Chrome"
  for file in "$chrome_dir"/Profile\ */Bookmarks; do
    [[ -e "$file" ]] && jq -r '.. | select(.type? == "url") | "\(.url)\t\(.name)\t\t\t\(.url)"' "$file"
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
      sqlite3 "$tmp" "SELECT url || char(9) || title || char(9) || char(9) || char(9) || url FROM urls ORDER BY last_visit_time DESC LIMIT 5000;" -separator $'\t'
    done
  } | awk -F'\t' '!seen[$5]++'
  rm -f "$tmp"
}

__omni-fzf-open-url() {
  local popup="$HOME/bin/omni/popup.sh"
  local fzf_opts="--with-nth=2..5 --delimiter=$'\t'"
  local selected
  selected=$(sed 's/^/_\t/' | __omni-engine-format | "$popup" $fzf_opts "$*")
  [[ -n "$selected" ]] && open "$(echo "$selected" | awk -F'\t' '{print $NF}')"
}

__omni-fzf-bookmarks() { __query-bookmarks | __omni-fzf-open-url "$@"; }
__omni-fzf-chrome-history() { __query-history | __omni-fzf-open-url "$@"; }
__omni-fzf-bookmarks-and-history() { { __query-bookmarks; __query-history; } | __omni-fzf-open-url "$@"; }

alias b='__omni-fzf-bookmarks'
alias h='__omni-fzf-chrome-history'
alias bh='__omni-fzf-bookmarks-and-history'
