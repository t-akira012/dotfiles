#!/bin/bash

direct_action() {
  zsh -ic "$1"
}

omni_search() {
  zsh -ic "__omni-search $1"
}

main() {
  local popup="$HOME/bin/func/fzf-tmux-popup.sh"
  local cmd
  cmd=$("$popup" --input "Omni: ")
  [[ -z "$cmd" ]] && exit 0

  if [[ ${#cmd} -le 2 ]]; then
    direct_action "$cmd"
  else
    omni_search "$cmd"
  fi
}

main
