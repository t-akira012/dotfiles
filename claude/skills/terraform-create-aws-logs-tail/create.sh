#!/usr/bin/env bash
set -euo pipefail

extract_declared_names() {
  find "${1}" -type f -name '*.tf' -print0 \
    | xargs -0 awk '
        FNR == 1 { in_block = 0; depth = 0 }
        /resource[[:space:]]+"aws_cloudwatch_log_group"/ { in_block = 1; depth = 0 }
        in_block {
          n_open = gsub(/{/, "{")
          n_close = gsub(/}/, "}")
          depth += n_open - n_close
          if ($0 ~ /^[[:space:]]*name[[:space:]]*=/) {
            name = $0
            sub(/^[^"]*"/, "", name)
            sub(/".*/, "", name)
            print name
          }
          if (depth <= 0 && (n_open + n_close) > 0) { in_block = 0 }
        }
      '
}

extract_known_names() {
  awk '
    /aws logs tail / {
      name = $0
      sub(/^.*aws logs tail /, "", name)
      sub(/[[:space:]].*/, "", name)
      print name
    }
  ' "${1}"
}

main() {
  target_dir="${1}"
  memo_file="${2}"

  test -d "${target_dir}"

  declared_names="$(extract_declared_names "${target_dir}")"
  test -n "${declared_names}"

  if test -f "${memo_file}"; then
    known_names="$(extract_known_names "${memo_file}")"
  else
    known_names=""
  fi

  appended=0
  while read -r name; do
    if printf '%s\n' "${known_names}" | grep -Fqx "${name}"; then
      continue
    fi
    printf 'aws logs tail %s --follow\n' "${name}" >>"${memo_file}"
    appended=$((appended + 1))
  done <<<"${declared_names}"

  printf 'MEMO_FILE:%s\n' "${memo_file}"
  printf 'APPENDED:%s\n' "${appended}"
}

main "${@}"

