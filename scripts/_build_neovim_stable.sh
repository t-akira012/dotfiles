#!/usr/bin/env bash

if [[ $(whoami) != "root" ]] ;then
  echo require root
  exit 1
fi

set -eux

USER=aki
DIR=/home/$USER

echo Build
git clone https://github.com/neovim/neovim.git -b stable --depth 1 /tmp/neovim-git
cd /tmp/neovim-git
make CMAKE_BUILD_TYPE=Release \
     CMAKE_INSTALL_PREFIX=$DIR/.local/ install
rm -rf /tmp/neovim-git
chown $USER:$USER $DIR/.local/bin/neovim
chmod 775 $DIR/.local/bin/neovim
