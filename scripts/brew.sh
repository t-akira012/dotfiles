#!/usr/bin/env bash
set -eu
echo === Install Homebrew

if which brew >>/dev/null 2>&1 ;then
  echo "Homebrew already installed."
else
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [[ `uname` == "Darwin" ]];then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif test -d ~/.linuxbrew >>/dev/null 2>&1 ;then
    eval "$(~/.linuxbrew/bin/brew shellenv)"
  fi
  brew doctor
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

