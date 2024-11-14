#!/usr/bin/env bash

sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove
sudo $HOME/dotfiles/scripts/install_firefox_dev.sh
$HOME/dotfiles/scripts/_build_neovim_stable.sh
