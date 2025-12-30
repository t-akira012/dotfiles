#!/usr/bin/env bash
set -eu
cd $(dirname $0)

if command -v git > /dev/null 2>&1;then
    git clone https://github.com/t-akira012/dotfiles
elif command -v curl > /dev/null 2>&1 ;then
    curl -L "https://github.com/t-akira012/dotfiles/archive/main.tar.gz" | tar zxv
    mv dotfiles-main "$HOME/dotfiles"
else
    echo 'require git or curl'
fi

bash -c "$HOME/dotfiles/init.sh"
