#!/usr/bin/env bash
#########################################################
echo Create symbolic links
#########################################################

BASEPATH=$HOME/dotfiles/root
[[ ! -d $HOME/.config ]] && mkdir $HOME/.config
ln -si $BASEPATH/bin $HOME/bin
ln -si $BASEPATH/.tmux.conf $HOME/.tmux.conf
ln -si $BASEPATH/.config/git $HOME/.config/git
ln -si $BASEPATH/.config/starship.toml $HOME/.config/starship.toml
ln -si $BASEPATH/root/.config/amethyst $HOME/.config/amethyst
