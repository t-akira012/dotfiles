#!/bin/bash
set -eu

target_browser="safari"

case "${target_browser}" in
	chrome)
		browser_path="/Applications/Google Chrome.app"
		;;
	safari)
		browser_path="/Applications/Safari.app"
		;;
	zen)
		browser_path="/Applications/Zen.app"
		;;
	*)
		echo "未対応のブラウザです: ${target_browser}" >&2
		exit 1
		;;
esac

if [[ ! -d "${browser_path}" ]]; then
	echo "ブラウザが見つかりません: ${browser_path}" >&2
	exit 1
fi

open_browser() {
	local url="${1}"

	if [[ "$(uname)" == "Darwin" ]]; then
		echo "${url}"
		open -a "${browser_path}" "${url}"
	else
		echo "${url}"
	fi
}

main() {
	if [[ $# -lt 1 ]]; then
		echo "Usage: $0 <URL>" >&2
		exit 1
	fi

	open_browser "${1}"
}

main "${@}"
