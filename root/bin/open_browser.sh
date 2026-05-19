#!/bin/bash
set -eu


if [[ -d "/Applications/Zen.app/" ]];then
	BROWSER="Zen"
elif [[ -d "/Applications/Google Chrome.app/" ]];then
	BROWSER="Google Chrome"
else

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
