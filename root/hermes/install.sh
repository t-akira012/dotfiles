#!/bin/bash
set -eu

INSTALL_TEMP_DIRECTORY=""

cleanup() {
  if test -n "${INSTALL_TEMP_DIRECTORY}"; then
    if test -d "${INSTALL_TEMP_DIRECTORY}"; then
      rm -r "${INSTALL_TEMP_DIRECTORY}"
    fi
  fi
}

get_script_directory() {
  local script_directory

  script_directory="$(dirname "$0")"
  cd "${script_directory}"
  pwd
}

require_command() {
  local command_name

  command_name="$1"
  if command -v "${command_name}" >/dev/null 2>&1; then
    return 0
  fi

  echo "[失敗] 必要なコマンドがありません: ${command_name}" >&2
  return 1
}

directory_has_entries() {
  local directory_path
  local first_entry

  directory_path="$1"
  first_entry="$(find "${directory_path}" -mindepth 1 -maxdepth 1 -print | sed -n '1p')"
  if test -n "${first_entry}"; then
    return 0
  fi
  return 1
}

prepare_private_repository() {
  local hermes_home

  hermes_home="$1"

  if test -d "${hermes_home}"; then
    if git -C "${hermes_home}" rev-parse --git-dir >/dev/null 2>&1; then
      echo "[スキップ] private Git repositoryは初期化済みです: ${hermes_home}"
      return 0
    fi
  fi

  if test -d "${hermes_home}"; then
    if directory_has_entries "${hermes_home}"; then
      echo "[失敗] Git管理されていない空でないディレクトリが存在します: ${hermes_home}" >&2
      return 1
    fi
  fi

  echo "[開始] local private Git repositoryを作成します: ${hermes_home}"
  mkdir -p "${hermes_home}"
  chmod 700 "${hermes_home}"
  git -C "${hermes_home}" init
  echo "[完了] local private Git repositoryを作成しました: ${hermes_home}"
}

create_private_remote() {
  local hermes_home

  hermes_home="$1"
  if git -C "${hermes_home}" remote get-url origin >/dev/null 2>&1; then
    echo "[スキップ] GitHub private repositoryは設定済みです"
    return 0
  fi

  echo "[確認] GitHub CLIの認証状態"
  gh auth status

  echo "[開始] GitHubにprivate repositoryを作成します: .hermes"
  gh repo create .hermes \
    --private \
    --source "${hermes_home}" \
    --remote origin \
    --description 'Private state and durable assets for Hermes Agent'
  echo "[完了] GitHub private repositoryを作成しました"
  git -C "${hermes_home}" remote -v
}

configure_allowlist() {
  local allowlist_path
  local hermes_home

  hermes_home="$1"
  allowlist_path="$2"

  if test -f "${allowlist_path}"; then
    echo "[開始] dotfilesのallowlistをGitへ設定します"
  else
    echo "[失敗] allowlistがありません: ${allowlist_path}" >&2
    return 1
  fi

  git -C "${hermes_home}" config --local core.excludesFile "${allowlist_path}"
  echo "[完了] core.excludesFile=${allowlist_path}"
}

download_installer() {
  local installer_path
  local installer_url

  installer_path="$1"
  installer_url='https://hermes-agent.nousresearch.com/install.sh'

  echo "[開始] Hermes Agent公式インストーラーを取得します"
  echo "[対象] ${installer_url}"
  curl --fail --location --output "${installer_path}" "${installer_url}"
  echo "[完了] 公式インストーラーを取得しました: ${installer_path}"
}

run_installer() {
  local installer_path

  installer_path="$1"
  echo "[開始] Hermes Agentをインストールします"
  bash "${installer_path}" --non-interactive
  echo "[完了] Hermes Agentをインストールしました"
}

find_hermes_command() {
  local local_command

  local_command="${HOME}/.local/bin/hermes"
  if test -x "${local_command}"; then
    echo "${local_command}"
    return 0
  fi

  if command -v hermes >/dev/null 2>&1; then
    command -v hermes
    return 0
  fi

  echo "[失敗] hermesコマンドが見つかりません" >&2
  return 1
}

verify_installation() {
  local doctor_status
  local hermes_command
  local hermes_home

  hermes_home="$1"
  hermes_command="$(find_hermes_command)"

  echo "[確認] Hermes Agentのバージョン"
  "${hermes_command}" --version

  echo "[確認] Hermes Agentの診断"
  if "${hermes_command}" doctor; then
    doctor_status=0
  else
    doctor_status=$?
  fi
  if test "${doctor_status}" -ne 0; then
    echo "[警告] hermes doctorは対応候補を報告しました: status=${doctor_status}"
    echo "[警告] 診断内容を確認してください。導入処理は継続します。"
  fi

  echo "[確認] private Git repositoryの管理対象"
  git -C "${hermes_home}" status --short
  echo "[完了] Hermes Agentの導入と検証が完了しました"
}

publish_initial_state() {
  local hermes_home

  hermes_home="$1"
  if git -C "${hermes_home}" rev-parse --verify HEAD >/dev/null 2>&1; then
    echo "[スキップ] private Git repositoryには既存のcommitがあります"
    return 0
  fi

  echo "[開始] allowlist対象を最初のcommitへ追加します"
  git -C "${hermes_home}" add --all
  if git -C "${hermes_home}" diff --cached --quiet; then
    echo "[スキップ] 最初のcommitへ追加するファイルがありません"
    return 0
  fi

  git -C "${hermes_home}" commit -m 'Initialize Hermes Agent state'
  echo "[開始] 最初のcommitをprivate repositoryへpushします"
  git -C "${hermes_home}" push --set-upstream origin HEAD
  echo "[完了] 最初のcommitをprivate repositoryへpushしました"
}

main() {
  local allowlist_path
  local hermes_home
  local installer_path
  local script_directory

  trap cleanup EXIT HUP INT TERM

  require_command bash
  require_command curl
  require_command find
  require_command gh
  require_command git
  require_command mktemp
  require_command sed

  script_directory="$(get_script_directory)"
  allowlist_path="${script_directory}/hermes.gitignore"
  hermes_home="${HOME}/.hermes"

  prepare_private_repository "${hermes_home}"
  configure_allowlist "${hermes_home}" "${allowlist_path}"
  create_private_remote "${hermes_home}"

  INSTALL_TEMP_DIRECTORY="$(mktemp -d /tmp/hermes-agent-install.XXXXXX)"
  installer_path="${INSTALL_TEMP_DIRECTORY}/install.sh"
  download_installer "${installer_path}"
  run_installer "${installer_path}"
  verify_installation "${hermes_home}"
  publish_initial_state "${hermes_home}"
}

main
