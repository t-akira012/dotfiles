__query-apps() {
  find /Applications -name "*.app" -type d -maxdepth 2 | sed 's|/Applications/||'
}

__action-apps() {
  open -a "/Applications/$(echo "$1" | cut -f1)"
}

__omni-fzf-open-app() {
  local popup="$HOME/bin/omni/popup.sh"
  local app=$(__query-apps | "$popup" "" "$*")
  [[ -n "$app" ]] && open -a "/Applications/$app"
}

alias a='__omni-fzf-open-app'
