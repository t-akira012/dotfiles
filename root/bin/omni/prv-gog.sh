__gog_cache_dir="$HOME/.local/cache/gog-function"

__gog_fetch-today-calendar() {
  local today_start today_end
  today_start="$(date +%Y-%m-%dT00:00:00%z)"
  today_end="$(date +%Y-%m-%dT23:59:59%z)"

  mkdir -p "$__gog_cache_dir"

  gog calendar calendars --json \
    | jq -r '.calendars[]? | [.id, .summary] | @tsv' \
    | while IFS=$'\t' read -r calendar_id calendar_name; do
        gog calendar events "$calendar_id" --from "$today_start" --to "$today_end" --json 2>/dev/null \
          | jq --arg name "$calendar_name" '.events |= map(. + {calendarName: $name})'
      done > "$__gog_cache_dir/calendar.json"
}

__gog_fetch-today-tasks() {
  mkdir -p "$__gog_cache_dir"

  gog tasks lists --json \
    | jq -r '.tasklists[]? | [.id, .title] | @tsv' \
    | while IFS=$'\t' read -r tasklist_id tasklist_name; do
        gog tasks list "$tasklist_id" --show-completed --show-hidden --json 2>/dev/null \
          | jq --arg lid "$tasklist_id" --arg lname "$tasklist_name" '.tasks |= map(. + {tasklistId: $lid, tasklistName: $lname})'
      done > "$__gog_cache_dir/tasks.json"
}

__action-today-calendar() {
  local url="$(echo "$1" | cut -f5)"
  [[ -n "$url" ]] && "${BROWSER:-open}" "$url"
}

__action-today-tasks() {
  local url="$(echo "$1" | cut -f5)"
  [[ -n "$url" ]] && "${BROWSER:-open}" "$url"
}

__query-today-calendar() {
  if [[ "$1" == "reload" ]] || [[ ! -f "$__gog_cache_dir/calendar.json" ]]; then
    __gog_fetch-today-calendar
  fi

  jq -r '.events[]? | "- (Calendar - " + (if .start.date then .start.date else ((.startLocal // .start.dateTime) | .[:10] + " " + .[11:16]) end) + " - " + (.calendarName // "") + ") " + (.summary // "(無題)") + "\t\t\t\t" + (.htmlLink // "")' "$__gog_cache_dir/calendar.json" \
    | sort -t$'\t' -k1
}

__query-today-tasks() {
  local today
  today="$(date +%Y-%m-%d)"

  if [[ "$1" == "reload" ]] || [[ ! -f "$__gog_cache_dir/tasks.json" ]]; then
    __gog_fetch-today-tasks
  fi

  jq -r --arg today "$today" \
    '.tasks[]? | select(.due != null) | select(.due[:10] == $today) | (if .status == "completed" then "0" else "1" end) + "\t" + (.tasklistName // "") + "\t" + "- [" + (if .status == "completed" then "x" else " " end) + "] (Tasks - " + .due[:10] + " - " + (.tasklistName // "") + ") " + ((.title // "(無題)") | split("\n")[0]) + "\t\t\t\t" + (.tasklistId // "") + "\t" + (.id // "") + "\t" + (.webViewLink // "")' "$__gog_cache_dir/tasks.json" \
    | grep '	- \[' \
    | sort -t$'\t' -k1,1 -k2,2 \
    | cut -f3-
}

__omni-fzf-today-calendar() {
  local popup="$HOME/bin/omni/popup.sh"
  local fzf_opts="--with-nth=1..4 --delimiter=$'\t' --preview-window=hidden"
  local selected
  selected="$(__query-today-calendar "$@" | "$popup" $fzf_opts)"

  [[ -z "$selected" ]] && return

  local url
  url="$(echo "$selected" | cut -f5)"
  [[ -n "$url" ]] && "${BROWSER:-open}" "$url"
}

__omni-fzf-today-tasks() {
  local popup="$HOME/bin/omni/popup.sh"
  local fzf_opts="--with-nth=1..4 --delimiter=$'\t' --preview-window=hidden --expect=ctrl-x"
  local selected key
  selected="$(__query-today-tasks "$@" | "$popup" $fzf_opts)"

  [[ -z "$selected" ]] && return

  key="$(echo "$selected" | head -1)"
  local line
  line="$(echo "$selected" | tail -1)"

  if [[ "$key" == "ctrl-x" ]]; then
    local tasklist_id task_id
    tasklist_id="$(echo "$line" | cut -f5)"
    task_id="$(echo "$line" | cut -f6)"
    if echo "$line" | grep -q '\- \[x\]'; then
      gog tasks undo "$tasklist_id" "$task_id"
    else
      gog tasks done "$tasklist_id" "$task_id"
    fi
    __gog_fetch-today-tasks &
  else
    local url
    url="$(echo "$line" | cut -f7)"
    [[ -n "$url" ]] && "${BROWSER:-open}" "$url"
  fi
}

__omni-fzf-today-all() {
  local popup="$HOME/bin/omni/popup.sh"
  local fzf_opts="--with-nth=1..4 --delimiter=$'\t' --preview-window=hidden --expect=ctrl-x"
  local selected key
  selected="$({ __query-today-calendar "$@"; __query-today-tasks "$@"; } | "$popup" $fzf_opts)"

  [[ -z "$selected" ]] && return

  key="$(echo "$selected" | head -1)"
  local line
  line="$(echo "$selected" | tail -1)"

  if [[ "$key" == "ctrl-x" ]]; then
    local tasklist_id task_id
    tasklist_id="$(echo "$line" | cut -f5)"
    task_id="$(echo "$line" | cut -f6)"
    if [[ -n "$tasklist_id" && -n "$task_id" ]]; then
      if echo "$line" | grep -q '\- \[x\]'; then
        gog tasks undo "$tasklist_id" "$task_id"
      else
        gog tasks done "$tasklist_id" "$task_id"
      fi
      __gog_fetch-today-tasks &
    fi
  else
    local url
    url="$(echo "$line" | cut -f7)"
    [[ -n "$url" ]] && "${BROWSER:-open}" "$url"
  fi
}

alias c='__omni-fzf-today-calendar'
alias t='__omni-fzf-today-tasks'
alias tc='__omni-fzf-today-all'
