__lazy_query-search() {
  local query="$1"
  [[ -z "$query" ]] && return 1
  "$HOME/bin/omni/curlDuckduckgo.sh" "$query" | awk -F'\t' -v OFS='\t' '{ print $1, $2, "", "", $1 }'
}

__action-search() {
  open "$(echo "$1" | awk -F'\t' '{print $NF}')"
}

__omni-fzf-web-search() {
  local query="$*"
  local popup="$HOME/bin/omni/popup.sh"
  if [[ -z "$query" ]]; then
    query=$("$popup" --input "Search: ")
    [[ -z "$query" ]] && return 1
  fi
  local tmp_data=$(mktemp)
  __lazy_query-search "$query" > "$tmp_data"
  local selected
  selected=$(awk -F'\t' '{printf "%-40.40s  %.70s\n", $1, $2}' "$tmp_data" | "$popup")
  if [[ -n "$selected" ]]; then
    local line=$(grep -nF "$selected" <(awk -F'\t' '{printf "%-40.40s  %.70s\n", $1, $2}' "$tmp_data") | head -1 | cut -d: -f1)
    local url=$(sed -n "${line}p" "$tmp_data" | cut -f1)
    open "$url"
  fi
  rm -f "$tmp_data"
}

alias s='__omni-fzf-web-search'
