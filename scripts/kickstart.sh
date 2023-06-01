#!/usr/bin/env bash

if which ghq >>/dev/null 2>&1 ;then
  ghq get -p t-akira012/kickstart.nvim
  ln -si $(ghq root)/github.com/t-akira012/kickstart.nvim $HOME/.config/nvim
fi
