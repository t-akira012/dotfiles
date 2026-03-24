#!/bin/bash
# popup.sh - generic tmux popup frontend for fzf
# Usage:
#   echo "data" | popup.sh                    -> select with fzf in popup
#   echo "data" | popup.sh "preview cmd {}"   -> select with preview
#   popup.sh --input "Prompt: "               -> user input in popup

input_read() {
  local prompt="$1" output_file="$2"
  tmux display-popup -E -w 60% -h 3 \
    "bash -c 'read -r -e -p \"$prompt\" q && printf \"%s\" \"\$q\" > \"$output_file\"'"
}

input_fzf() {
  local prompt="$1" output_file="$2" history_file="$3"
  tmux display-popup -E -w 60% -h 40% \
    "fzf --prompt='$prompt' --no-info --scheme=history --tac --bind='tab:replace-query,enter:become(echo {q})' < '$history_file' > '$output_file'" || true
}

save_history() {
  echo "$1" >> "$2"
  sort "$2" | uniq > "$2.tmp" && mv "$2.tmp" "$2"
}

select_mode() {
  local query="${@: -1}"
  local fzf_opts="${*:1:$#-1}"
  local fifo=$(mktemp -u)
  local output_file=$(mktemp)
  mkfifo "$fifo"
  tmux display-popup -E -w 80% -h 60% \
    "fzf $fzf_opts --query='$query' < '$fifo' > '$output_file'" &
  cat > "$fifo" 2>/dev/null
  wait 2>/dev/null
  cat "$output_file"
  rm -f "$fifo" "$output_file"
  return 0
}

main() {
  if [[ "$1" != "--input" ]]; then
    select_mode "$@"
    return
  fi

  local prompt="${2:-Input: }"
  local history_file="$HOME/.cache/omni/history"
  local output_file=$(mktemp)
  mkdir -p "${history_file%/*}"
  touch "$history_file"

  # fzfは使わない
  input_read "$prompt" "$output_file"

  local result
  result=$(head -1 "$output_file")
  rm -f "$output_file"
  [[ -z "$result" ]] && return
  save_history "$result" "$history_file"
  printf '%s' "$result"
}

main "$@"
