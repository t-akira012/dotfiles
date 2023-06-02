#!/usr/bin/env bash
set -e
brew install nodenv

echo インストールするバージョンを入力
read -p "未入力の場合 latest にします: " version
test -z $version \
  && version="$(nodenv install -l | grep -E "^[0-9]+(\.[0-9]+){2}" | sort -V | tail -1)"

echo Install version is $version

eval "$(nodenv init -)"
nodenv install $version
nodenv global $version
npm i -g npm yarn

echo node version is $(nodenv version)
echo npm version is $(npm -v)
echo yarn version is $(yarn -v)

echo done.
