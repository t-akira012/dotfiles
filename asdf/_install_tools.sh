#!/usr/bin/env bash
cd $(dirname $0)

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

# fzf
[[ ! -d $HOME/.local/bin ]] && mkdir -p $HOME/.local/bin/
curl -s https://raw.githubusercontent.com/junegunn/fzf/master/bin/fzf-preview.sh -o $HOME/.local/bin/fzf-preview.sh
chmod +x $HOME/.local/bin/fzf-preview.sh



#########################################################
echo Install rust tools
#########################################################
source "$HOME/.cargo/env"
cargo install \
    ripgrep \
    exa \
    bat \
    fd-find
