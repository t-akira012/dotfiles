#!/bin/bash
# run a single shell command via tmux popup input
POPUP="$HOME/bin/func/fzf-tmux-popup.sh"
CMD=$("$POPUP" --input "Launch: ")
[[ -z "$CMD" ]] && exit 0

check_cmd(){
  if ! zsh -ic "command -v ${CMD%% *}" >/dev/null 2>&1; then
    CMD=""
  fi
}
case "${CMD%% *}" in
  b|s|a|t|c|tc|p) check_cmd ;;
  *) CMD="__fzf-search $CMD" ;;
esac
[[ -n "$CMD" ]] && zsh -ic "$CMD"
exit 0
