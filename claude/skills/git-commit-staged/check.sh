#!/usr/bin/env bash
set -euo pipefail

require_global_user() {
  if ! git config --global --get user.name >/dev/null 2>&1; then
    printf 'ABORT: global user.name が未設定です\n' >&2
    return 1
  fi
  if ! git config --global --get user.email >/dev/null 2>&1; then
    printf 'ABORT: global user.email が未設定です\n' >&2
    return 1
  fi
  local name email
  name="$(git config --global --get user.name)"
  email="$(git config --global --get user.email)"
  printf 'GLOBAL_USER: %s <%s>\n' "${name}" "${email}"
}

require_staged() {
  if git diff --cached --quiet; then
    printf 'ABORT: staged 変更がありません\n' >&2
    return 1
  fi
}

emit_material() {
  printf '\n--- STAGED FILES ---\n'
  git diff --cached --name-status
  printf '\n--- RECENT LOG ---\n'
  git log --oneline -n 10
  printf '\n--- STAGED DIFF ---\n'
  git diff --cached
}

main() {
  require_global_user
  require_staged
  emit_material
}

main
