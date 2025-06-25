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

check(){
  local LANG_NAME=$1
  echo =================================
  echo "Plugin install $LANG_NAME"
  echo =================================
  if ! asdf plugin add $LANG_NAME > /dev/null 2>&1;then
    asdf plugin add $LANG_NAME
  fi

  asdf install $LANG_NAME latest
  asdf global $LANG_NAME latest
  which $LANG_NAME

  if [[ $LANG_NAME == "nodejs" ]];then
    npm i -g npm yarn
    node -v
    npm -v
    yarn -v
  fi

  if [[ $LANG_NAME == "python" ]];then
    if ! type uv >/dev/null 2>&1 ; then
      # https://docs.astral.sh/uv/#getting-started
      curl -LsSf https://astral.sh/uv/install.sh | sh
    fi
  fi
}

check go
check nodejs
check python
check ruby

if ! type cargo > /dev/null 2>&1;then
  ./rust.sh
fi

