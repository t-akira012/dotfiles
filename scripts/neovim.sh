#!/usr/bin/env bash

#########################################################
echo Install noevim.
#########################################################

if ! type nvim; then
    if [[ $(uname) == "Darwin" ]]; then
        brew install nvim
    elif type apt; then
        sudo apt update
        sudo apt install -y systemtap-sdt-dev gettext
        ./_build_neovim_stable.sh
    fi
fi

#########################################################
echo kickstart.nvim
#########################################################

if which ghq >>/dev/null 2>&1 ;then
    ghq get t-akira012/kickstart.nvim
    ln -si $(ghq root)/github.com/t-akira012/kickstart.nvim $HOME/.config/nvim
else
    echo "require ghq"
fi
