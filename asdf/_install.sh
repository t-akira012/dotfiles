#!/usr/bin/env bash
cd $(dirname $0)

# TODO: asdfを消す
brew install go uv fnm

if ! type cargo > /dev/null 2>&1;then
  ./rust.sh
fi

