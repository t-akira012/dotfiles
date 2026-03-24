__query-switch-app() {
  "$HOME/bin/omni/bin/swift-window-list"
}

__action-switch-app() {
  local app_name
  app_name=$(echo "$1" | awk -F'\t' '{print $NF}')
  osascript -e "tell application \"$app_name\" to activate"
}

__omni-fzf-switch-app() {
  local popup="$HOME/bin/omni/popup.sh"
  local selected
  selected=$(__query-switch-app | sed 's/^/_\t/' | __omni-engine-format | "$popup" --with-nth=2..5 --delimiter=$'\t' "$*")
  [[ -n "$selected" ]] && __action-switch-app "$selected"
}

alias w='__omni-fzf-switch-app'
