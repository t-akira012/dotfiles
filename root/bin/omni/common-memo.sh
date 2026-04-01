# __query-n-memo: col2以降を出力（col1の型は__omni-engine-searchが付与）
# 出力: col2=ファイル名(表示), col3-5=空, col6=ファイル名(隠蔽)
__query-n-memo() {
  [[ ! -d "$MEMO_DIR/keep" ]] && return
  rg --files "$MEMO_DIR/keep" 2>/dev/null | sort | sed 's|.*/||; s/\.md$//' | awk '{print $0 "\t\t\t\t" $0}'
}

# __action-n-memo: __query-*出力（型プレフィックスなし）を受け取る
# 隠蔽列からファイル名を取得: awk '{print $NF}'
__action-n-memo() {
  local name="$(echo "$1" | awk -F'\t' '{print $NF}')"
  "$HOME/bin/memo-controller.sh" "$MEMO_DIR/keep" "/" "$name"
}

# __omni-fzf-n-memo: standalone fzf関数
# dummy type付与: sed 's/^/_\t/' | __omni-engine-format
# add/a サブコマンド: 先頭語を消費し残りをmemo-controller.shに委譲
__omni-fzf-n-memo() {
  local args="$*"
  local first="${args%% *}"
  if [[ "$first" == "add" || "$first" == "a" ]]; then
    local rest="${args#* }"
    "$HOME/bin/memo-controller.sh" "$MEMO_DIR/keep" "/" "$rest"
    return
  fi
  local popup="$HOME/bin/omni/popup.sh"
  local selected
  selected=$(__query-n-memo | sed 's/^/_\t/' | __omni-engine-format | "$popup" "--with-nth=2..5 --delimiter=$'\t'" "$args")
  [[ -z "$selected" ]] && return
  local body="$(echo "$selected" | cut -f2-)"
  __action-n-memo "$body"
}
alias n='__omni-fzf-n-memo'
