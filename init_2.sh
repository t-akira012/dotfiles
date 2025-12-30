#!/usr/bin/env bash
mkdir $HOME/tmp
mkdir $HOME/src
mkdir $HOME/dev
cp ./.ex $HOME/.ex

./init_2/create_symlink.sh
./init_2/add_git_config.sh
./init_2/download_git_completion.sh
./init_2/forzsh.sh
./init_2/neovim.sh
if [[ $(uname) == "Darwin" ]];then
	./init_2/create_icloud_symlink.sh
	./init_2/defaults_write.sh
	./init_2/install-clipper-macos.sh
fi

./asdf/_install.sh

echo '== install tools =='
echo './asdf/_install_tools.sh'
