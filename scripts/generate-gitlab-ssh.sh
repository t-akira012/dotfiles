#!/usr/bin/env bash
set -eu

[[ ! -d $HOME/.ssh ]] && mkdir $HOME/.ssh

echo What is your email address?
read email

echo Add ssh key to gitlab
if [ ! -e "$HOME/.ssh/id_gitlab" ]; then
  cd $HOME/.ssh
  ssh-keygen -t ed25519 -C ""
  touch config
  cat <<_EOF_ >>config

Host *.gitlab.com
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_gitlab
_EOF_

  cat $HOME/.ssh/id_gitlab.pub
  echo Finished.
fi
