#!/usr/bin/env bash
set -eux
cd $(dirname $0)

#########################################################
echo Install Go
#########################################################

if type go >/dev/null 2>&1 ;then
    echo "Go already installed."
else
    asdf install golang latest
    asdf global golang latest
    go version
fi
