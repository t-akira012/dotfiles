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

if [[ -d /home/linxbrew ]]; then
	echo Install linuxbrew packages
	brew install z bash-completion
fi

if [[ $(uname) == "Darwin" ]]; then
	echo Install Homebrew packages
	brew install \
		git gh curl wget tree tmux watch expect z unar nvim shfmt bash-completion git-delta

	echo '=== Install packages for macOS'
	brew install \
		gnu-sed gawk coreutils binutils findutils util-linux

	echo '=== Install cask packages'
	brew install --cask google-chrome
	brew install --cask visual-studio-code
	brew install --cask coteditor
	brew install --cask iterm2
	brew install --cask karabiner-elements
	brew install --cask alfred
	brew install --cask rectangle
	brew install --cask alt-tab
	brew install --cask slack

	brew tap homebrew/cask-fonts
	brew install font-plemol-jp
	brew install font-plemol-jp-nf
	brew install font-plemol-jp-hs
	brew install font-hackgen font-hackgen-nerd
fi
