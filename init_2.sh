#!/usr/bin/env bash
mkdir $HOME/tmp
mkdir $HOME/src
mkdir $HOME/dev
cp ./.ex $HOME/.ex

./init_2_create_symlink.sh
./init_2_add_git_config.sh
./init_2_download_git_completion.sh
[[ $(uname) == "Darwin" ]] && bash -c ./init_2_create_icloud_symlink.sh

./scripts/forzsh.sh
./asdf/_install.sh
./asdf/_install_tools.sh

# ./scripts/neovim.sh
