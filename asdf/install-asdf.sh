#!/usr/bin/env bash

if [[ ! -d $HOME/.asdf ]];then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.12.0
fi

if [[ -f $HOME/.asdf/asdf.sh ]];then
    . $HOME/.asdf/asdf.sh
else
    echo require asdf.bash
    exit 1
fi

plugins=(nodejs python ruby go)
for p in "${plugins[@]}"; do
    asdf plugin add $p
    asdf install $p latest
    asdf global $p latest
done

echo for nodejs
npm i -g npm yarn
