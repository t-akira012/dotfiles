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
}

require_staged() {
  if git diff --cached --quiet; then
    printf 'ABORT: staged 変更がありません\n' >&2
    return 1
  fi
}

do_commit() {
  local message name email
  message="$1"
  name="$(git config --global --get user.name)"
  email="$(git config --global --get user.email)"
  GIT_COMMITTER_NAME="${name}" GIT_COMMITTER_EMAIL="${email}" \
    git commit --author="${name} <${email}>" -m "${message}"
}

main() {
  if [ "$#" -ne 1 ]; then
    printf 'ABORT: 承認済みコミットメッセージを引数1個で渡してください\n' >&2
    return 2
  fi
  require_global_user
  require_staged
  do_commit "$1"
}

main "$@"
