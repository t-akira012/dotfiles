__fzf-open-app(){
    local popup="$HOME/bin/func/fzf-tmux-popup.sh"
    local app=$(find /Applications -name "*.app" -type d -maxdepth 2 | sed 's|/Applications/||' | "$popup")
    [[ -n "$app" ]] && open -a "/Applications/$app"
}

__fzf-search() {
  local query="$*"
  local popup="$HOME/bin/func/fzf-tmux-popup.sh"
  if [[ -z "$query" ]]; then
    query=$("$popup" --input "Search: ")
    [[ -z "$query" ]] && return 1
  fi
  local tmp_data=$(mktemp)
  "$HOME/bin/func/curlDuckduckgo.sh" "$query" > "$tmp_data"
  local selected
  selected=$(awk -F'\t' '{printf "%-40.40s  %.70s\n", $1, $2}' "$tmp_data" | "$popup")
  if [[ -n "$selected" ]]; then
    local line=$(grep -nF "$selected" <(awk -F'\t' '{printf "%-40.40s  %.70s\n", $1, $2}' "$tmp_data") | head -1 | cut -d: -f1)
    local url=$(sed -n "${line}p" "$tmp_data" | cut -f1)
    open "$url"
  fi
  rm -f "$tmp_data"
}

alias s='__fzf-search'
alias a='__fzf-open-app'

alias tw='$HOME/bin/func/fzf-tmux-window.sh'
