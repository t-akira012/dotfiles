#!/usr/bin/env bash
set -euo pipefail

main() {
  local height="${1}"
  local input_dir="${2}"
  local output_dir="${input_dir}/resize_h${height}"
  mkdir -p "${output_dir}"
  shopt -s nullglob
  local source_file
  for source_file in "${input_dir}"/*.jpg "${input_dir}"/*.jpeg "${input_dir}"/*.JPG "${input_dir}"/*.JPEG; do
    sips --resampleHeight "${height}" "${source_file}" --out "${output_dir}/$(basename "${source_file}")"
  done
}

main "$@"
