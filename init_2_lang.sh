#!/usr/bin/env bash
cd $(dirname $0)

[[ ! -d $HOME/.local/ ]] && mkdir $HOME/.local/
[[ ! -d $HOME/.local/repos ]] && mkdir $HOME/.local/repos
[[ ! -d $HOME/.local/bin ]] && mkdir $HOME/.local/bin

# TODO: asdfを消す
brew install go uv fnm tfenv

#########################################################
echo Install Rust
#########################################################
#
if ! type cargo > /dev/null 2>&1 ;then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
else
    echo "Rust already installed."
fi


#########################################################
echo Install deno
#########################################################

if which deno >>/dev/null 2>&1 ;then
    echo "Deno already installed."
    exit 0
fi

curl -fsSL https://deno.land/x/install/install.sh | sh

#########################################################
echo Install Go packages
#########################################################

go install golang.org/x/tools/cmd/goimports@latest
go install golang.org/x/tools/gopls@latest
go install github.com/google/yamlfmt/cmd/yamlfmt@latest

brew install ghq fzf


#########################################################
echo Install rust tools
#########################################################
source "$HOME/.cargo/env"
cargo install \
    ripgrep \
    exa \
    bat \
    fd-find \
    starship
