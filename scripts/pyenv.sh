#!/usr/bin/env bash
set -eu
brew install pyenv

echo インストールするバージョンを入力
read -p "未入力の場合 latest にします: " version
test -z $version \
  && version=$(pyenv install --list | grep -v '[a-zA-Z]' | grep -e '\s3\.?*' | tail -1)

echo Install version is $version

pyenv install $version
pyenv global $version

pyenv version

echo done.
