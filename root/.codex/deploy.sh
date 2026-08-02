#!/usr/bin/env bash
set -eu

get_script_dir() {
  local script_directory

  script_directory="$(dirname -- "$0")"
  cd -- "$script_directory"
  pwd
}

validate_destination() {
  local script_directory
  local destination
  local current_target

  script_directory="$1"
  destination="$2"

  if test -L "$destination"; then
    current_target="$(readlink "$destination")"
    if test "$current_target" = "$script_directory"; then
      echo "[スキップ] $destination はすでに $script_directory を参照しています"
      return 1
    fi

    echo "[エラー] $destination はすでに $current_target へのシンボリックリンクです" >&2
    echo "手動で移動または削除してから、このスクリプトを再実行してください。" >&2
    return 2
  fi

  if test -e "$destination"; then
    echo "[エラー] $destination はすでに存在します。" >&2
    echo "必要な内容を $script_directory へ移し、既存ディレクトリを手動で移動または削除してください。" >&2
    return 2
  fi

  return 0
}

main() {
  local script_directory
  local destination
  local validation_status

  script_directory="$(get_script_dir)"
  destination="$HOME/.codex"

  if validate_destination "$script_directory" "$destination"; then
    validation_status=0
  else
    validation_status=$?
  fi
  if test "$validation_status" -eq 1; then
    exit 0
  fi
  if test "$validation_status" -ne 0; then
    exit "$validation_status"
  fi

  ln -s "$script_directory" "$destination"
  echo "[リンク作成] $script_directory -> $destination"
}

main
