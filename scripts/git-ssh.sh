#!/usr/bin/env bash
set -eu

echo Add ssh key to github
if [ ! -e "$HOME/.ssh/id_ed25519" ]; then
  cd $HOME/.ssh
  ssh-keygen -t ed25519 -C "$GIT_EMAIL"
  touch config
  cat <<_EOF_ >config
Host *.github.com
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_ed25519
_EOF_

  cat $HOME/.ssh/id_ed25519.pub
  echo Open github settings SSH keys
  echo URL:
  echo   https://github.com/settings/keys
  read -p "Enter: "
fi
