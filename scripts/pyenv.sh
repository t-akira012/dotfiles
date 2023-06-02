#!/usr/bin/env bash
set -eu
echo インストールするバージョンを入力
read -p "未入力の場合 latest にします: " version
test -z $version \
  && version=$(pyenv install --list | grep -v '[a-zA-Z]' | grep -e '\s3\.?*' | tail -1)

echo Install version is $version

brew install pyenv
pyenv install $version
pyenv global $version

pyenv version

echo done.
