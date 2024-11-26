#!/usr/bin/env bash
cd $(dirname $0)

mkdir $HOME/.config/git-hooks
cp ./pre-push $HOME/.config/git-hooks/pre-push
chmod +x $HOME/.config/git-hooks/pre-push
git config --global core.hooksPath $HOME/.config/git-hooks
