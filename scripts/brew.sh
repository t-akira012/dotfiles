#!/usr/bin/env bash
set -eu
echo === Install Homebrew

if which brew >>/dev/null 2>&1 ;then
  echo "Homebrew already installed."
else
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew doctor
  [[ `uname` == "Darwin" ]] \
    && eval "$(/opt/homebrew/bin/brew shellenv)" \
    || test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
fi

echo === Install Homebrew packages

brew install \
  git \
  gh \
  curl \
  wget \
  tree \
  tmux \
  watch \
  expect \
  z \
  unar \
  nvim \
  coreutils \
  binutils \
  findutils \
  gnu-sed \
  gawk \
  shfmt \

brew tap homebrew/cask-fonts \
  && brew install font-hackgen font-hackgen-nerd

