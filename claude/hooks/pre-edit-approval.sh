#!/usr/bin/env bash
set -euo pipefail
# Claude Code PreToolUse hook: ロックファイル方式でWrite/Edit前の合意を強制

PERMIT_FILE="/tmp/claude-edit-permit"

allow() {
  rm -f "$PERMIT_FILE"
}

block() {
  cat <<'JSON'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "変更内容をユーザーに説明し合意を得なさい。合意後に touch /tmp/claude-edit-permit を実行してから再試行せよ。"
  }
}
JSON
}

main() {
  if [[ -f "$PERMIT_FILE" ]]; then
    allow
  else
    block
  fi
}

main
