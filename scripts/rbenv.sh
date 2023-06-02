#!/usr/bin/env bash
set -e

brew install rbenv ruby-build
echo インストールするバージョンを入力
read -p "未入力の場合 latest にします: " version
test -z $version \
  && version=$(rbenv install -l | grep -v - | tail -1)
echo Install version is $version

rbenv install $version
rbenv global $version

rbenv version

echo done.
