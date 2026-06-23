#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: compress_jpeg.sh <size(%)> <input-directory>" >&2
  exit 1
}

require_converter() {
  if ! command -v sips >/dev/null 2>&1; then
    echo "Error: sips not found. This script requires macOS sips." >&2
    exit 1
  fi
}

compress_one() {
  local source_file="${1}"
  local output_file="${2}"
  local quality="${3}"
  if [ -e "${output_file}" ]; then
    echo "Error: output already exists: ${output_file}" >&2
    exit 1
  fi
  sips -s format jpeg -s formatOptions "${quality}" "${source_file}" --out "${output_file}"
}

main() {
  if [ "${#}" -ne 2 ]; then
    usage
  fi
  local quality="${1}"
  local input_dir="${2}"
  if ! [[ "${quality}" =~ ^[0-9]+$ ]]; then
    usage
  fi
  if [ "${quality}" -lt 1 ] || [ "${quality}" -gt 100 ]; then
    usage
  fi
  if [ ! -d "${input_dir}" ]; then
    usage
  fi
  require_converter

  shopt -s nullglob
  local source_files=("${input_dir}"/*.jpg "${input_dir}"/*.jpeg "${input_dir}"/*.JPG "${input_dir}"/*.JPEG)
  shopt -u nullglob
  if [ "${#source_files[@]}" -eq 0 ]; then
    echo "Error: no JPEG files in ${input_dir}" >&2
    exit 1
  fi

  local output_dir="${input_dir}/output_${quality}"
  mkdir -p "${output_dir}"

  local source_file
  for source_file in "${source_files[@]}"; do
    local base_name
    base_name="$(basename "${source_file}")"
    local stem="${base_name%.*}"
    local output_file="${output_dir}/${stem}.jpg"
    compress_one "${source_file}" "${output_file}" "${quality}"
    echo "compressed: ${source_file} -> ${output_file}"
  done
}

main "$@"
