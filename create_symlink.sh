#!/usr/bin/env bash
#########################################################
echo Create symbolic links
#########################################################

BASEPATH=$HOME/dotfiles/root

for_all(){
  [[ ! -d $HOME/.config ]] && mkdir $HOME/.config

  [[ -e $HOME/.bashrc ]] && mv "$HOME/.bashrc" "$HOME/.bashrc.bak.$(date +"%Y%m%d_%H%M")"
  symlink $BASEPATH/.bashrc $HOME/.bashrc

  [[ -e $HOME/.zshrc ]] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak.$(date +"%Y%m%d_%H%M")"
  symlink $BASEPATH/.config/zsh $HOME/.config/zsh
  symlink $BASEPATH/.config/zsh/.zshrc $HOME/.zshrc

  symlink $BASEPATH/bin $HOME/bin
  symlink $BASEPATH/.tmux.conf $HOME/.tmux.conf
  symlink $BASEPATH/.config/git $HOME/.config/git
  symlink $BASEPATH/.config/starship.toml $HOME/.config/starship.toml
  symlink $BASEPATH/.config/alacritty/ $HOME/.config/alacritty
}

symlink(){
  if [[ ! -e $2 ]];then
    ln -si $1 $2
  else
    echo "$2 is already exist"
    [[ ! -L $2 ]] && echo "$2 がシンボックリンクではありません"
  fi
}

for_darwin(){
  :
}

for_linux(){
  symlink $BASEPATH/root/.config/xremap $HOME/.config/xremap
}

for_all

[ "$(uname)" == "Darwin" ] && for_darwin
[ "$(uname)" == "Linux" ] && for_linux
