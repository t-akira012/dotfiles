#!/usr/bin/env bash
set -eu
cd $(dirname $0)

clone_zsh_function(){
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
}

pure_install(){
  # pure install
  cd $HOME/.config/zsh/repos/pure
  ln -s "$PWD/pure.zsh" $HOME/.config/zsh/zfunc/prompt_pure_setup
  ln -s "$PWD/async.zsh" $HOME/.config/zsh/zfunc/async
}


if [ -L $HOME/.config/zsh ]; then
  clone_zsh_function
  # pure_install
  chsh -s $(which zsh)
else
  echo ".config/zshがsymlinkではない"
fi

