#!/usr/bin/env bash
set -eu
cd $(dirname $0)

if type apt > /dev/null 2>&1;then
    sudo apt update && \
        sudo apt install -y \
        git build-essential coreutils \
        cmake gettext fontconfig \
        gh curl wget tree tmux watch expect unar shfmt xsel wl-clipboard bash-completion zsh
fi

if type pacman > /dev/null 2>&1;then
    sudo pacman-mirrors --fasttrack && sudo pacman -Syy
    yes | sudo pacman -S \
        yay \
        git base-devel coreutils \
        github-cli curl wget tree tmux expect unarchiver shfmt xsel wl-clipboard bash-completion git-delta make
    sudo pacman -Scc
fi

if [[ $(uname) == "Darwin" ]];then
    echo "[ -f ~/.bashrc ] && . ~/.bashrc" >> $HOME/.bash_profile
    bash -c ./init_1_homebrew_for_mac.sh
fi


echo 'init.sh 終了'
bash -c ./init_2.sh
