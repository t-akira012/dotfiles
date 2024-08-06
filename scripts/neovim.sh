#!/usr/bin/env bash
cd $(dirname $0)

#########################################################
echo Install neovim.
#########################################################

if ! type nvim >/dev/null 2>&1; then
    if [[ $(uname) == "Darwin" ]]; then
        brew install nvim
    elif type apt >/dev/null 2>&1; then
        sudo apt update
        sudo apt install -y systemtap-sdt-dev gettext
        ./_build_neovim_stable.sh
    elif type pacman >/dev/null 2>&1; then
        sudo pacman -Syy
        yes | sudo pacman -S neovim
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
