#!/bin/bash
# fzf-tmux-popup.sh - generic tmux popup frontend for fzf
# Usage:
#   echo "data" | fzf-tmux-popup.sh                    -> select with fzf in popup
#   echo "data" | fzf-tmux-popup.sh "preview cmd {}"   -> select with preview
#   fzf-tmux-popup.sh --input "Prompt: "               -> user input in popup

input_mode() {
  local PROMPT="${1:-Input: }"
  local TMP=$(mktemp)
  tmux display-popup -E -w 60% -h 3 \
    "bash -c 'read -r -e -p \"$PROMPT\" q && printf \"%s\" \"\$q\" > \"$TMP\"'"
  cat "$TMP"
  rm -f "$TMP"
}

select_mode() {
  local INPUT_FZF_LIST=$(mktemp)
  local OUTPUT_FZF_SELECTED=$(mktemp)
  cat > "$INPUT_FZF_LIST"
  tmux display-popup -E -w 80% -h 60% "fzf < '$INPUT_FZF_LIST' > '$OUTPUT_FZF_SELECTED'" || true
  cat "$OUTPUT_FZF_SELECTED"
  rm -f "$INPUT_FZF_LIST" "$OUTPUT_FZF_SELECTED"
}

main() {
  [[ "$1" == "--input" ]] && { input_mode "$2"; return; }
  select_mode "$1"
}

main "$@"
