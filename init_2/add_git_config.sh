#!/usr/bin/env bash
#########################################################
echo "Add git config"
#########################################################

if [[ ! -L $HOME/.config/git ]];then
  echo "$HOME/.config/git がシンボリックリンクではありません"
fi
cp $HOME/.config/git/config.template $HOME/.config/git/config
git config --global ghq.root ~/src
git config --global alias.st status
git config --global alias.sw switch
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.l "log --graph"
git config --global alias.dfc "diff --cached"
git config --global pull.rebase false
git config --global diff.tool vimdiff
git config --global difftool.prompt false
git config --global diff.colorMoved dimmed-zebra
git config --global diff.colorMovedWS allow-indentation-change
git config --global grep.lineNumber true
git config --global core.quotepath false
git config --global init.defaultBranch main
