#!/usr/bin/env bash
echo === Create symbolic links

BASEPATH=$HOME/dotfiles/root

[[ ! -d $HOME/.config ]] && mkdir $HOME/.config

ln -si $BASEPATH/bin $HOME/bin

ln -si $BASEPATH/.tmux.conf $HOME/.tmux.conf

ln -si $BASEPATH/.config/git $HOME/.config/git
ln -si $BASEPATH/.config/zsh $HOME/.config/zsh
ln -si $BASEPATH/.config/zellij $HOME/.config/zellij

ln -si $BASEPATH/.bashrc $HOME/.bashrc
ln -si $BASEPATH/.config/zsh/.zshrc $HOME/.zshrc
