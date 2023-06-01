#!/usr/bin/env bash
cd $(dirname $0)

[[ -d $HOME/dotfiles ]] && \
  echo "dotfiles already exists" && \
  exit 1

clone(){
  git clone https://github.com/t-akira012/pub-dotfiles
  mv pub-dotfiles $HOME/dotfiles
}
download(){

  local tarball=https://github.com/t-akira012/pub-dotfiles/archive/main.tar.gz
  if type curl; then
    curl -L $tarball | tar zxv
  elif type wget; then
    wget -O - $tarball | tar zxv
  else
    echo 'curl or wget required'
  fi
  mv pub-dotfiles-main $HOME/dotfiles
}

main(){
  if type git ;then
    clone
  else
    download
  fi
  $HOME/dotfiles/init.sh
}

main
