#!/usr/bin/env bash
set -eu
cd $(dirname $0)

curl -L "https://github.com/t-akira012/dotfiles/archive/main.tar.gz" | tar zxv
mv dotfiles-main "$HOME/dotfiles"
bash -c "$HOME/dotfiles/init.sh"
