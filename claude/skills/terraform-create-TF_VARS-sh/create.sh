#!/usr/bin/env bash
set -euo pipefail

extract_declared_names() {
  awk '
    /^[[:space:]]*variable[[:space:]]+"/ {
      name = $0
      sub(/^[^"]*"/, "", name)
      sub(/".*/, "", name)
      print name
    }
  ' "${1}"
}

extract_known_names() {
  awk '
    /^[[:space:]]*export[[:space:]]+TF_VAR_/ {
      name = $0
      sub(/^[^=]*TF_VAR_/, "", name)
      sub(/=.*/, "", name)
      print name
    }
  ' "${1}"
}

main() {
  target_dir="${1}"
  main_tf="${target_dir}/main.tf"
  vars_file="${target_dir}/TF_VARS.sh"

  test -f "${main_tf}"

  declared_names="$(extract_declared_names "${main_tf}")"
  test -n "${declared_names}"

  if test -f "${vars_file}"; then
    known_names="$(extract_known_names "${vars_file}")"
  else
    known_names=""
  fi

  appended=0
  while read -r name; do
    if printf '%s\n' "${known_names}" | grep -qx "${name}"; then
      continue
    fi
    printf 'export TF_VAR_%s=xxx\n' "${name}" >>"${vars_file}"
    appended=$((appended + 1))
  done <<<"${declared_names}"

  printf 'VARS_FILE:%s\n' "${vars_file}"
  printf 'APPENDED:%s\n' "${appended}"
}

main "${@}"
