#!/usr/bin/env bash
cd $(dirname $0)

[[ -d $HOME/dotfiles ]] && \
  echo "dotfiles already exists" && \
  exit 1

download(){

  local tarball=https://github.com/t-akira012/dotfiles/archive/main.tar.gz
  if type curl; then
    curl -L $tarball | tar zxv
  elif type wget; then
    wget -O - $tarball | tar zxv
  else
    echo 'curl or wget required'
  fi
  mv dotfiles-main $HOME/dotfiles
}

main(){
  if type git ;then
    git clone https://github.com/t-akira012/dotfiles
  else
    download
  fi
  $HOME/dotfiles/init.sh
}

main
