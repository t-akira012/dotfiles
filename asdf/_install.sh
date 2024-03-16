#!/usr/bin/env bash

if [[ ! -d $HOME/.asdf ]];then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.12.0
fi

if [[ -f $HOME/.asdf/asdf.sh ]];then
    . $HOME/.asdf/asdf.sh
else
    echo require asdf.sh
    exit 1
fi

asdf plugin add golang
asdf plugin add ruby
asdf plugin add python
asdf plugin add nodejs

