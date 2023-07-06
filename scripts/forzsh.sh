#!/usr/bin/env bash
set -eu
cd $(dirname $0)

echo Create symbolic links
BASEPATH=$HOME/dotfiles/root
[[ ! -d $HOME/.config ]] && mkdir $HOME/.config
ln -si $BASEPATH/.config/zsh $HOME/.config/zsh
ln -si $BASEPATH/.config/zsh/.zshrc $HOME/.zshrc

echo Clone zsh function

[[ ! -d ~/.config/zsh ]] && \
  echo "zsh config directory not found" && \
  exit 1

cd $HOME/.config/zsh

[[ ! -d repos ]] && mkdir repos
[[ ! -d zfunc ]] && mkdir zfunc

cd $HOME/.config/zsh/repos

git clone https://github.com/zsh-users/zsh-syntax-highlighting --depth 1
git clone https://github.com/zsh-users/zsh-autosuggestions --depth 1
git clone https://github.com/zsh-users/zsh-completions --depth 1
git clone https://github.com/intelfx/pure --depth 1
git clone https://github.com/ohmyzsh/ohmyzsh --depth 1
git clone https://github.com/Tarrasch/zsh-bd --depth 1

# pure install
cd $HOME/.config/zsh/repos/pure
ln -s "$PWD/pure.zsh" $HOME/.config/zsh/zfunc/prompt_pure_setup
ln -s "$PWD/async.zsh" $HOME/.config/zsh/zfunc/async

