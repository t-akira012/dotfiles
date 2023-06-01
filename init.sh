#!/usr/bin/env bash
set -eu
cd $(dirname $0)

if [[ "$SHELL" != *zsh ]];then
  [[ $(uname) == "Darwin" ]] && chsh -s $(which zsh)
fi

./scripts/brew.sh
./scripts/install-go.sh
./scripts/install-rust.sh
./scripts/install-deno.sh
./scripts/create-sym-links.sh
./scripts/install-git-completion.sh
./scripts/install-zsh-tools.sh
./scripts/install-brew-cask-packages.sh
./scripts/kickstart.sh
./scripts/set-git-config.sh
# ./scripts/set-git-user.sh
