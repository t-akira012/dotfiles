#!/usr/bin/env bash
set -euo pipefail
# Claude Code PostToolUse hook: Write/Edit後に変更内容を報告

emit_context() {
  cat <<'JSON'
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "【必須】今実行したWrite/Editの変更内容をユーザーに報告せよ。対象ファイル、変更・追加・削除された内容を箇条書きで具体的に述べなさい。ロジック単位で意図を説明すること。"
  }
}
JSON
}

main() {
  emit_context
}

main
