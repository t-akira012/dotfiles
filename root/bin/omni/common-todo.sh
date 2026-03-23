TASK_MD="$HOME/docs/doc/DRAFT.md"

__action-todo() {
  local line_num="$(echo "$1" | cut -f1 | cut -d: -f1)"
  if ! tmux select-window -t :9 2>/dev/null; then
    tmux new-window -t :9 -n doc
    tmux send-keys -t :9 "$EDITOR +${line_num} ${TASK_MD}" Enter
  elif [[ "$(tmux list-panes -t :9 -F '#{pane_current_command}')" == "nvim" ]]; then
    tmux send-keys -t :9 ":tabnew +${line_num} ${TASK_MD}" Enter
  else
    tmux send-keys -t :9 "$EDITOR +${line_num} ${TASK_MD}" Enter
  fi
}

__query-todo() {
  [[ -f "$TASK_MD" ]] && grep -n '^ *\- \[[ x]\]' "$TASK_MD"
}

__omni-fzf-todo() {
  local popup="$HOME/bin/omni/popup.sh"
  local selected
  selected="$(__query-todo | "$popup" --expect=ctrl-x,ctrl-o)"

  [[ -z "$selected" ]] && return

  local key line
  key="$(echo "$selected" | head -1)"
  line="$(echo "$selected" | tail -1)"

  local line_num="${line%%:*}"
  if [[ "$key" == "ctrl-x" ]]; then
    if echo "$line" | grep -q '\- \[x\]'; then
      sed -i '' "${line_num}s/\- \[x\]/- [ ]/" "$TASK_MD"
    else
      sed -i '' "${line_num}s/\- \[ \]/- [x]/" "$TASK_MD"
    fi
    __omni-fzf-todo
  elif [[ "$key" == "ctrl-o" ]]; then
    local stamp=$(date '+%m/%d %H:%M')
    sed -i '' "${line_num}s|$| ${stamp}|" "$TASK_MD"
    __omni-fzf-todo
  else
    if ! tmux select-window -t :9 2>/dev/null; then
      tmux new-window -t :9 -n doc
      tmux send-keys -t :9 "$EDITOR +${line_num} ${TASK_MD}" Enter
    elif [[ "$(tmux list-panes -t :9 -F '#{pane_current_command}')" == "nvim" ]]; then
      tmux send-keys -t :9 ":tabnew +${line_num} ${TASK_MD}" Enter
    else
      tmux send-keys -t :9 "$EDITOR +${line_num} ${TASK_MD}" Enter
    fi
  fi
}
