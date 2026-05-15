#!/bin/bash
set -eu

BROWSER="Zen"

open_browser() {
	local url="${1}"
	if [[ "$(uname)" == "Darwin" ]]; then
		echo "${url}"
		open -a "${BROWSER}" "${url}"
	else
		echo "${url}"
	fi
}

main() {
	open_browser "${1}"
}

main "${@}"
