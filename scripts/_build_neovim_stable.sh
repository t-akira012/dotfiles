#!/usr/bin/env bash

if [[ $(whoami) == "root" ]] ;then
  echo rootで実行しないこと
  exit 1
fi
set -eux

echo Build
rm -rf /tmp/neovim-git
git clone https://github.com/neovim/neovim.git -b stable --depth 1 /tmp/neovim-git
cd /tmp/neovim-git
make CMAKE_BUILD_TYPE=Release \
     CMAKE_INSTALL_PREFIX=$HOME/.local/ install
cd $HOME/dotfiles/scripts
rm -rf $HOME/neovim-git
