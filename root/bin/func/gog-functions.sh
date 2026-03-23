#!/usr/bin/env bash
# __gog_fetch-today-calendar — Calendar API から JSON 取得・キャッシュ保存
# __gog_fetch-today-tasks — Tasks API から JSON 取得・キャッシュ保存
# __gog_get-today-calendar [reload] — キャッシュからカレンダー整形出力
# __gog_get-today-tasks [reload] — キャッシュからタスク整形出力
# __gog_fzf-today-calendar [reload] — fzf で選択 → $BROWSER で開く
# __gog_fzf-today-tasks [reload] — fzf で選択 → $BROWSER で開く

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
    | jq -r '.tasklists[]?.id' \
    | while read -r tasklist_id; do
        gog tasks list "$tasklist_id" --show-completed --show-hidden --json 2>/dev/null
      done > "$__gog_cache_dir/tasks.json"
}

__gog_get-today-calendar() {
  if [[ "$1" == "reload" ]] || [[ ! -f "$__gog_cache_dir/calendar.json" ]]; then
    __gog_fetch-today-calendar
  fi

  jq -r '.events[]? | (.htmlLink // "") + "\t" + "- [ ] (Calendar - " + (if .start.date then .start.date else ((.startLocal // .start.dateTime) | .[:10] + " " + .[11:16]) end) + " - " + (.calendarName // "") + ") " + (.summary // "(無題)")' "$__gog_cache_dir/calendar.json" \
    | grep '	- \[ \]' \
    | sort -t$'\t' -k2
}

__gog_get-today-tasks() {
  local today
  today="$(date +%Y-%m-%d)"

  if [[ "$1" == "reload" ]] || [[ ! -f "$__gog_cache_dir/tasks.json" ]]; then
    __gog_fetch-today-tasks
  fi

  jq -r --arg today "$today" \
    '.tasks[]? | select(.due != null) | select(.due[:10] == $today) | (.webViewLink // "") + "\t" + "- [" + (if .status == "completed" then "x" else " " end) + "] (Tasks - " + .due[:10] + ") " + ((.title // "(無題)") | split("\n")[0])' "$__gog_cache_dir/tasks.json" \
    | grep '	- \[' \
    | sort -r -t$'\t' -k2
}

__gog_fzf-today-calendar() {
  local selected
  selected="$(__gog_get-today-calendar "$@" | fzf --with-nth=2.. --delimiter=$'\t' --preview-window=hidden)"

  [[ -z "$selected" ]] && return

  local url
  url="$(echo "$selected" | cut -f1)"
  [[ -n "$url" ]] && "${BROWSER:-open}" "$url"
}

__gog_fzf-today-tasks() {
  local selected
  selected="$(__gog_get-today-tasks "$@" | fzf --with-nth=2.. --delimiter=$'\t' --preview-window=hidden)"

  [[ -z "$selected" ]] && return

  local url
  url="$(echo "$selected" | cut -f1)"
  [[ -n "$url" ]] && "${BROWSER:-open}" "$url"
}

__gog_fzf-today-all() {
  local selected
  selected="$({ __gog_get-today-calendar "$@"; __gog_get-today-tasks "$@"; } | fzf --with-nth=2.. --delimiter=$'\t' --preview-window=hidden)"

  [[ -z "$selected" ]] && return

  local url
  url="$(echo "$selected" | cut -f1)"
  [[ -n "$url" ]] && "${BROWSER:-open}" "$url"
}

alias c='__gog_fzf-today-calendar'
alias t='__gog_fzf-today-tasks'
alias ct='__gog_fzf-today-all'
