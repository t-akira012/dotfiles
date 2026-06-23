#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: heic_to_jpeg.sh <input-directory>" >&2
  exit 1
}

require_converter() {
  if ! command -v sips >/dev/null 2>&1; then
    echo "Error: sips not found. This script requires macOS sips." >&2
    exit 1
  fi
}

convert_one() {
  local source_file="${1}"
  local output_file="${2}"
  if [ -e "${output_file}" ]; then
    echo "Error: output already exists: ${output_file}" >&2
    exit 1
  fi
  sips --setProperty format jpeg "${source_file}" --out "${output_file}"
}

main() {
  if [ "${#}" -ne 1 ]; then
    usage
  fi
  local input_dir="${1}"
  if [ ! -d "${input_dir}" ]; then
    usage
  fi
  require_converter

  shopt -s nullglob
  local source_files=("${input_dir}"/*.heic "${input_dir}"/*.HEIC)
  shopt -u nullglob
  if [ "${#source_files[@]}" -eq 0 ]; then
    echo "Error: no HEIC files in ${input_dir}" >&2
    exit 1
  fi

  local output_dir="${input_dir}/output-jpeg"
  mkdir -p "${output_dir}"

  local source_file
  for source_file in "${source_files[@]}"; do
    local base_name
    base_name="$(basename "${source_file}")"
    local stem="${base_name%.*}"
    local output_file="${output_dir}/${stem}.jpg"
    convert_one "${source_file}" "${output_file}"
    echo "converted: ${source_file} -> ${output_file}"
  done
}

main "$@"
