#!/usr/bin/env bash -eux
cd $(dirname $0)

ln -si "$PWD" $HOME/.claude
ln -si "$PWD" $HOME/.config/claude
