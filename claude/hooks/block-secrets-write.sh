#!/usr/bin/env bash
set -euo pipefail
# Claude Code PreToolUse hook: block writes containing secrets patterns

SECRETS_PATTERNS=(
  'AKIA[0-9A-Z]{16}'
  'sk-[a-zA-Z0-9]{20,}'
  'ghp_[a-zA-Z0-9]{36}'
  'gho_[a-zA-Z0-9]{36}'
  'glpat-[a-zA-Z0-9\-_]{20,}'
  '-----BEGIN.*PRIVATE KEY'
  'password\s*=\s*['"'"'"][^'"'"'"]+['"'"'"]'
)

build_pattern() {
  local joined=""
  for p in "${SECRETS_PATTERNS[@]}"; do
    [[ -n "$joined" ]] && joined+="|"
    joined+="$p"
  done
  printf '%s' "$joined"
}

check_input() {
  local input pattern
  input=$(cat)
  pattern=$(build_pattern)

  if echo "$input" | grep -qE "$pattern"; then
    cat <<'JSON'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "Secrets pattern detected in write content"
  }
}
JSON
  fi
}

main() {
  check_input
}

main
