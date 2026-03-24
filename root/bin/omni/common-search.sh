# サフィックス → 短縮型（単一情報源）
typeset -A __omni_engine_type_map=(
  apps        a
  search      s
  today-calendar c
  today-tasks gt
  projects    p
  bookmarks   b
  history     h
  todo        t
  tmux-windows tw
  urls        u
)

# 逆引き（短縮型 → サフィックス）を自動生成
typeset -A __omni_engine_action_map
for __k __v in ${(kv)__omni_engine_type_map}; do
  __omni_engine_action_map[$__v]=$__k
done
unset __k __v

__omni-engine-format() {
  awk -F'\t' -v OFS='\t' '{$2 = sprintf("%-50.50s", $2); print}'
}

__omni-engine-dispatch() {
  local selected="$1"
  [[ -z "$selected" ]] && return
  local type="$(echo "$selected" | cut -f1)"
  local suffix="${__omni_engine_action_map[$type]:-$type}"
  local body="$(echo "$selected" | cut -f2-)"
  "__action-${suffix}" "$body"
}

__omni-engine-search() {
  local query="$1"
  [[ -z "$query" ]] && return

  local popup="$HOME/bin/omni/popup.sh"
  local tmp_data=$(mktemp)
  for func in ${(k)functions[(I)__query-*]}; do
    local suffix="${func#__query-}"
    local type="${__omni_engine_type_map[$suffix]:-$suffix}"
    "$func" "$query" 2>/dev/null | sed "s/^/${type}\t/"
  done > "$tmp_data"

  local selected
  selected=$(cat "$tmp_data" | __omni-engine-format | "$popup" "--with-nth=1..5 --delimiter=$'\t' --tabstop=8 --query=$query")
  selected=$(echo "$selected" | sed 's/[[:space:]]*\t/\t/g; s/[[:space:]]*$//')

  __omni-engine-dispatch "$selected"
  rm -f "$tmp_data"
}

__omni-fzf-search() {
  local popup="$HOME/bin/omni/popup.sh"
  local query=$("$popup" --input "Omni: ")
  __omni-engine-search "$query"
}
