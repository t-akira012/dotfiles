#!/usr/bin/env bash
cd $(dirname $0)

#########################################################
echo Install Go packages
#########################################################

go install golang.org/x/tools/cmd/goimports@latest
go install golang.org/x/tools/gopls@latest
go install github.com/google/yamlfmt/cmd/yamlfmt@latest
go install github.com/x-motemen/ghq@latest


# fzf
[[ ! -d $HOME/.local/ ]] && mkdir $HOME/.local/
[[ ! -d $HOME/.local/repos ]] && mkdir $HOME/.local/repos
[[ ! -d $HOME/.local/bin ]] && mkdir $HOME/.local/bin
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.local/repos/fzf
bash -c $HOME/.local/repos/fzf/install
cp $HOME/.local/repos/fzf/bin/fzf $HOME/.local/bin/fzf
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
    fd-find \
    starship
