#!/usr/bin/env bash
set -euo pipefail
# Claude Code PreToolUse hook: 誤った設定ファイルへの書き込みをブロック

deny_with_reason() {
  local reason="$1"
  cat <<JSON
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "$reason"
  }
}
JSON
}

check_path() {
  local file_path
  file_path=$(jq -r '.tool_input.file_path // ""')
  case "$file_path" in
    */settings.local.json|*/.claude/settings.json)
      deny_with_reason "設定ファイルの編集先が間違っています。~/.config/claude/settings.json を読んでから編集してください。"
      ;;
  esac
}

main() {
  check_path
}

main
