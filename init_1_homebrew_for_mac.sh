#!/usr/bin/env bash
set -eu
cd $(dirname $0)

echo Install Homebrew

_eval_brew() {
	if [[ -e /opt/homebrew/bin/brew ]]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	elif test -d /home/linuxbrew >>/dev/null 2>&1; then
		eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
	else
		echo 'You must install homebrew.'
	fi
}

_eval_brew
if type brew >>/dev/null 2>&1; then
	echo "Homebrew already installed."
else
	echo "Installing homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	_eval_brew
fi

if [[ -d /home/linuxbrew ]]; then
	echo Install linuxbrew packages
	brew install z bash-completion
fi

if [[ $(uname) == "Darwin" ]]; then
	echo "=== Install Homebrew packages"
	brew install --quiet \
		git gh curl wget tree tmux watch expect z unar nvim shfmt bash-completion git-delta

	echo "=== Install GNU core packages for macOS"
	brew install --quiet \
		gnu-sed gawk coreutils binutils findutils util-linux

	echo "=== Install cask packages"

	CASKS=(
		google-chrome
		zen
		firefox@developer-edition
		coteditor
		ghostty
		karabiner-elements
		raycast
		rectangle
		alt-tab
		dropbox
		discord
		slack
		vlc
		zoom
	)

	for app in "${CASKS[@]}"; do
		if ! brew list --cask "$app" >/dev/null 2>&1; then
			echo "Installing $app ..."
			brew install --cask "$app" --quiet
		else
			echo "$app already installed."
		fi
	done

fi
