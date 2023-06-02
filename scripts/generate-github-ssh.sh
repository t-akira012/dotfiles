#!/usr/bin/env bash
set -eu

echo What are you email address?
read email

echo Add ssh key to github
if [ ! -e "$HOME/.ssh/id_ed25519" ]; then
  cd $HOME/.ssh
  ssh-keygen -t ed25519 -C ""
  touch config
  cat <<_EOF_ >config
Host *.github.com
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_ed25519
_EOF_

  cat $HOME/.ssh/id_ed25519.pub
  echo Open github settings SSH keys
  echo URL:
  echo https://github.com/settings/keys
  echo
  echo Finished.
fi
