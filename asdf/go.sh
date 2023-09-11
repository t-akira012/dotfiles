#!/usr/bin/env bash
set -eux

#########################################################
echo Install Go
#########################################################

if type go >>/dev/null 2>&1 ;then
    echo "Go already installed."
else
    asdf plugin add golang
    asdf install golang latest
    asdf global golang latest
    go version
fi

#########################################################
echo Install Go packages
#########################################################

go install golang.org/x/tools/cmd/goimports@latest
go install golang.org/x/tools/gopls@latest
go install github.com/google/yamlfmt/cmd/yamlfmt@latest

[[ ! -d $HOME/.local/repos ]] && mkdir $HOME/.local/repos

git clone --depth 1 https://github.com/x-motemen/ghq $HOME/.local/repos/ghq \
    && cd $HOME/.local/repos/ghq/ \
    && make install

git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.local/repos/fzf \
    && $HOME/.local/repos/fzf/install

