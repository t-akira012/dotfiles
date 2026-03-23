#!/bin/bash
# fzf-tmux-popup.sh - generic tmux popup frontend for fzf
# Usage:
#   echo "data" | fzf-tmux-popup.sh                    -> select with fzf in popup
#   echo "data" | fzf-tmux-popup.sh "preview cmd {}"   -> select with preview
#   fzf-tmux-popup.sh --input "Prompt: "               -> user input in popup

input_mode() {
  local prompt="${1:-Input: }"
  local tmp=$(mktemp)
  tmux display-popup -E -w 60% -h 3 \
    "bash -c 'read -r -e -p \"$prompt\" q && printf \"%s\" \"\$q\" > \"$tmp\"'"
  cat "$tmp"
  rm -f "$tmp"
}

select_mode() {
  local tmp_in=$(mktemp)
  local tmp_out=$(mktemp)
  cat > "$tmp_in"
  local fzf_opts=""
  [[ -n "$1" ]] && fzf_opts="--preview '$1'"
  tmux display-popup -E -w 80% -h 60% "fzf $fzf_opts < '$tmp_in' > '$tmp_out'" || true
  cat "$tmp_out"
  rm -f "$tmp_in" "$tmp_out"
}

main() {
  [[ "$1" == "--input" ]] && { input_mode "$2"; return; }
  select_mode "$1"
}

main "$@"
