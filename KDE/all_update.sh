#!/usr/bin/env bash

# crontab -e
SCRIPT_DIR=$(dirname $0)

if [[ $(whoami) != "root" ]];then
  echo require sudo
  exit 0
fi

apt update -y
apt upgrade -y
apt autoremove
$SCRIPT_DIR/../scripts/install_firefox_dev.sh
$SCRIPT_DIR/../scripts/_build_neovim_stable.sh
