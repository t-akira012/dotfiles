#!/usr/bin/env bash
set -eu
if [[ $(uname) != "Darwin" ]];then
  echo "This script is only for macOS"
  exit 1
fi

brew install --cask google-chrome
brew install --cask visual-studio-code
brew install --cask coteditor
brew install --cask iterm2
brew install --cask karabiner-elements
brew install --cask alfred
brew install --cask rectangle
brew install --cask alt-tab
brew install --cask slack
