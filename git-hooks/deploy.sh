#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

HOOKS_DIR="${HOME}/.config/git-hooks"

backup() {
  target_path="${1}"
  test -e "${target_path}" || return 0
  stamp="$(date +%Y%m%d-%H%M%S)"
  mv "${target_path}" "${target_path}.bak.${stamp}"
  echo "Backed up ${target_path} to ${target_path}.bak.${stamp}"
}

deploy() {
  mkdir -p "${HOOKS_DIR}"
  backup "${HOOKS_DIR}/pre-push"
  backup "${HOOKS_DIR}/pre-commit"
  cp ./pre-push "${HOOKS_DIR}/pre-push"
  cp ./pre-commit "${HOOKS_DIR}/pre-commit"
  chmod +x "${HOOKS_DIR}/pre-push" "${HOOKS_DIR}/pre-commit"
  git config --global core.hooksPath "${HOOKS_DIR}"
  echo "Deployed to ${HOOKS_DIR}"
}

main() {
  deploy
}

main
