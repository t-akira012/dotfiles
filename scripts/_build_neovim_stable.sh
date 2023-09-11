#!/usr/bin/env bash
set -eux

echo Build
git clone https://github.com/neovim/neovim.git -b stable --depth 1 $HOME/neovim-git
cd $HOME/neovim-git
make CMAKE_BUILD_TYPE=Release \
     CMAKE_INSTALL_PREFIX=$HOME/.local/ install
cd $HOME/dotfiles/scripts
rm -rf $HOME/neovim-git
