#!/usr/bin/env bash
./create_symlink.sh
./add_git_config.sh
./download_git_completion.sh
cp ./.ex $HOME/.ex

./scripts/forzsh.sh
./asdf/_install.sh
./asdf/_install_tools.sh

# ./scripts/neovim.sh
