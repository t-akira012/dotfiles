#!/usr/bin/env bash
cd $(dirname $0)

if [[ ! -d $HOME/.asdf ]];then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.12.0
fi

if [[ -f $HOME/.asdf/asdf.sh ]];then
    . $HOME/.asdf/asdf.sh
else
    echo require asdf.sh
    exit 1
fi

if ! type go > /dev/null 2>&1;then
  asdf plugin add golang
  ./asdf/go.sh
fi
if ! type ruby > /dev/null 2>&1;then
  asdf plugin add ruby
  ./asdf/ruby.sh
fi
if ! type python > /dev/null 2>&1;then
  asdf plugin add python
  ./asdf/python.sh
fi

if ! type node > /dev/null 2>&1;then
  asdf plugin add nodejs
  ./asdf/nodejs.sh
fi

if ! type cargo > /dev/null 2>&1;then
  ./asdf/rust.sh
fi

./_install_tools.sh
