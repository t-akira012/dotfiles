#!/usr/bin/env bash
set -eu
if which ghq >>/dev/null 2>&1 ;then
  echo === install kickstart nvim
  ghq get -p t-akira012/kickstart.nvim
  ln -si $(ghq root)/github.com/t-akira012/kickstart.nvim $HOME/.config/nvim
else
  echo "require ghq"
fi
