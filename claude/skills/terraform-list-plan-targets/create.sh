#!/usr/bin/env bash
set -euo pipefail

extract_declared_names() {
  awk '
    /^[[:space:]]*module[[:space:]]+"/ {
      name = $0
      sub(/^[^"]*"/, "", name)
      sub(/".*/, "", name)
      print name
    }
  ' "${1}"
}

extract_known_names() {
  awk '
    /-target=module\./ {
      name = $0
      sub(/^.*-target=module\./, "", name)
      sub(/[[:space:]].*/, "", name)
      print name
    }
  ' "${1}"
}

main() {
  target_dir="${1}"
  main_tf="${target_dir}/main.tf"
  memo_file="${target_dir}/GIT_IGNORED_SCRATCH.md"

  test -f "${main_tf}"

  declared_names="$(extract_declared_names "${main_tf}")"
  test -n "${declared_names}"

  if test -f "${memo_file}"; then
    known_names="$(extract_known_names "${memo_file}")"
  else
    known_names=""
  fi

  appended=0
  while read -r name; do
    if printf '%s\n' "${known_names}" | grep -qx "${name}"; then
      continue
    fi
    printf 'terraform plan -target=module.%s\n' "${name}" >>"${memo_file}"
    appended=$((appended + 1))
  done <<<"${declared_names}"

  printf 'MEMO_FILE:%s\n' "${memo_file}"
  printf 'APPENDED:%s\n' "${appended}"
}

main "${@}"
