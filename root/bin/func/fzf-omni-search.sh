# 短縮型 → query関数サフィックス
typeset -A __omni_type_map=(
  apps        a
  search      s
  today-calendar c
  today-tasks gt
  projects    p
  bookmarks   b
  todo        t
)

# 短縮型 → action関数サフィックス（逆引き）
typeset -A __omni_action_map=(
  a  apps
  s  search
  c  today-calendar
  gt today-tasks
  p  projects
  b  bookmarks
  t  todo
)

__omni-format() {
  awk -F'\t' -v OFS='\t' '{$2 = sprintf("%-50.50s", $2); print}'
}

__omni-action() {
  local selected="$1"
  [[ -z "$selected" ]] && return
  local type="$(echo "$selected" | cut -f1)"
  local suffix="${__omni_action_map[$type]:-$type}"
  local body="$(echo "$selected" | cut -f2- | sed 's/[[:space:]]*\t/\t/g; s/[[:space:]]*$//')"
  "__action-${suffix}" "$body"
}

__fzf-omni-search() {
  local popup="$HOME/bin/func/fzf-tmux-popup.sh"
  local query
  query=$("$popup" --input "Omni: ")
  [[ -z "$query" ]] && return

  local tmp_data=$(mktemp)
  for func in ${(k)functions[(I)__query-*]}; do
    local suffix="${func#__query-}"
    local type="${__omni_type_map[$suffix]:-$suffix}"
    "$func" "$query" 2>/dev/null | sed "s/^/${type}\t/"
  done > "$tmp_data"

  local selected
  selected=$(cat "$tmp_data" | __omni-format | "$popup" "--with-nth=1..5 --delimiter=$'\t' --tabstop=8 --query=$query")

  __omni-action "$selected"
  rm -f "$tmp_data"
}
