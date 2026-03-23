#!/usr/bin/env bash
# __gog_fetch-today-calendar — Calendar API から JSON 取得・キャッシュ保存
# __gog_fetch-today-tasks — Tasks API から JSON 取得・キャッシュ保存
# __gog_get-today-calendar [reload] — キャッシュからカレンダー整形出力
# __gog_get-today-tasks [reload] — キャッシュからタスク整形出力
# __gog_fzf-today-calendar [reload] — fzf で選択 → $BROWSER で開く
# __gog_fzf-today-tasks [reload] — fzf で選択 → done/undo トグル、ctrl-o で $BROWSER
# __gog_fzf-today-all [reload] — calendar + tasks を fzf で選択

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

__gog_get-today-calendar() {
  if [[ "$1" == "reload" ]] || [[ ! -f "$__gog_cache_dir/calendar.json" ]]; then
    __gog_fetch-today-calendar
  fi

  jq -r '.events[]? | "\t\t" + (.htmlLink // "") + "\t" + "- [ ] (Calendar - " + (if .start.date then .start.date else ((.startLocal // .start.dateTime) | .[:10] + " " + .[11:16]) end) + " - " + (.calendarName // "") + ") " + (.summary // "(無題)")' "$__gog_cache_dir/calendar.json" \
    | sort -t$'\t' -k4
}

__gog_get-today-tasks() {
  local today
  today="$(date +%Y-%m-%d)"

  if [[ "$1" == "reload" ]] || [[ ! -f "$__gog_cache_dir/tasks.json" ]]; then
    __gog_fetch-today-tasks
  fi

  jq -r --arg today "$today" \
    '.tasks[]? | select(.due != null) | select(.due[:10] == $today) | (if .status == "completed" then "0" else "1" end) + "\t" + (.tasklistName // "") + "\t" + (.tasklistId // "") + "\t" + (.id // "") + "\t" + (.webViewLink // "") + "\t" + "- [" + (if .status == "completed" then "x" else " " end) + "] (Tasks - " + .due[:10] + " - " + (.tasklistName // "") + ") " + ((.title // "(無題)") | split("\n")[0])' "$__gog_cache_dir/tasks.json" \
    | grep '	- \[' \
    | sort -t$'\t' -k1,1 -k2,2 \
    | cut -f3-
}

__gog_fzf-today-calendar() {
  local selected
  selected="$(__gog_get-today-calendar "$@" | fzf --with-nth=4.. --delimiter=$'\t' --preview-window=hidden)"

  [[ -z "$selected" ]] && return

  local url
  url="$(echo "$selected" | cut -f3)"
  [[ -n "$url" ]] && "${BROWSER:-open}" "$url"
}

__gog_fzf-today-tasks() {
  local selected key
  selected="$(__gog_get-today-tasks "$@" | fzf --with-nth=4.. --delimiter=$'\t' --preview-window=hidden --expect=ctrl-x)"

  [[ -z "$selected" ]] && return

  key="$(echo "$selected" | head -1)"
  local line
  line="$(echo "$selected" | tail -1)"

  if [[ "$key" == "ctrl-x" ]]; then
    local tasklist_id task_id
    tasklist_id="$(echo "$line" | cut -f1)"
    task_id="$(echo "$line" | cut -f2)"
    if echo "$line" | grep -q '\- \[x\]'; then
      gog tasks undo "$tasklist_id" "$task_id"
    else
      gog tasks done "$tasklist_id" "$task_id"
    fi
    __gog_fetch-today-tasks &
  else
    local url
    url="$(echo "$line" | cut -f3)"
    [[ -n "$url" ]] && "${BROWSER:-open}" "$url"
  fi
}

__gog_fzf-today-all() {
  local selected key
  selected="$({ __gog_get-today-calendar "$@"; __gog_get-today-tasks "$@"; } | fzf --with-nth=4.. --delimiter=$'\t' --preview-window=hidden --expect=ctrl-x)"

  [[ -z "$selected" ]] && return

  key="$(echo "$selected" | head -1)"
  local line
  line="$(echo "$selected" | tail -1)"

  if [[ "$key" == "ctrl-x" ]]; then
    local tasklist_id task_id
    tasklist_id="$(echo "$line" | cut -f1)"
    task_id="$(echo "$line" | cut -f2)"
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
    url="$(echo "$line" | cut -f3)"
    [[ -n "$url" ]] && "${BROWSER:-open}" "$url"
  fi
}

alias c='__gog_fzf-today-calendar'
alias t='__gog_fzf-today-tasks'
alias tc='__gog_fzf-today-all'
