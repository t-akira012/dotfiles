#!/usr/bin/env bash
set -euo pipefail
# Claude Code PreToolUse hook: block writes containing secrets patterns or sensitive variable assignments

SECRETS_PATTERNS=(
  'AKIA[0-9A-Z]{16}'
  'ASIA[0-9A-Z]{16}'
  '[a-zA-Z0-9+/]{40}'
  'sk-[a-zA-Z0-9]{20,}'
  'ghp_[a-zA-Z0-9]{36}'
  'gho_[a-zA-Z0-9]{36}'
  'glpat-[a-zA-Z0-9_-]{20,}'
  'xox[bpsa]-[0-9A-Za-z_/-]+'
  '-----BEGIN.*PRIVATE KEY'
)

VARIABLE_KEYWORDS=(
  key token secret password passwd credential auth
  apikey access_key signing_key encryption_key
  client_secret client_id bearer jwt session cookie
  cert certificate passphrase pin salt hmac
  oauth webhook dsn connection_string conn_str
)

build_secrets_pattern() {
  local joined=""
  for p in "${SECRETS_PATTERNS[@]}"; do
    [[ -n "$joined" ]] && joined+="|"
    joined+="$p"
  done
  printf '%s' "$joined"
}

build_variable_pattern() {
  local joined=""
  for k in "${VARIABLE_KEYWORDS[@]}"; do
    [[ -n "$joined" ]] && joined+="|"
    joined+="$k"
  done
  printf '%s' "[a-zA-Z0-9_]*($joined)[a-zA-Z0-9_]*=['\"]?[^[:space:]'\"]+['\"]?"
}

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

check_input() {
  local input secrets_pattern variable_pattern
  input=$(cat)
  secrets_pattern=$(build_secrets_pattern)
  variable_pattern=$(build_variable_pattern)

  if echo "$input" | grep -qEi "$secrets_pattern"; then
    deny_with_reason "シークレットパターンを検出しました。ファイル書き込みを禁止します。内容を画面に表示し、ユーザーにコピーアンドペーストでの手動書き込みを提案してください。"
    return
  fi

  if echo "$input" | grep -qEi "$variable_pattern"; then
    deny_with_reason "センシティブな変数代入を検出しました。ファイル書き込みを禁止します。内容を画面に表示し、ユーザーにコピーアンドペーストでの手動書き込みを提案してください。"
    return
  fi
}

main() {
  check_input
}

main
