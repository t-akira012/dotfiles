#!/usr/bin/env bash
mkdir $HOME/tmp
mkdir $HOME/src
mkdir $HOME/dev
cp ./.ex $HOME/.ex

./init_2_create_symlink.sh
./init_2_add_git_config.sh
./init_2_download_git_completion.sh
if [[ $(uname) == "Darwin" ]];then
	bash -c ./init_2_create_icloud_symlink.sh
	bash -c ./scripts/defaults_write.sh
fi

./scripts/forzsh.sh
./scripts/neovim.sh
./asdf/_install.sh
./asdf/_install_tools.sh

echo '== git user を設定 =='
./scripts/set-git-user.sh
