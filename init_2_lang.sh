#!/usr/bin/env bash
cd $(dirname $0)

[[ ! -d $HOME/.local/ ]] && mkdir $HOME/.local/
[[ ! -d $HOME/.local/repos ]] && mkdir $HOME/.local/repos
[[ ! -d $HOME/.local/bin ]] && mkdir $HOME/.local/bin

brew install go uv fnm tfenv python3

install_uv_tools(){
    uv tool install black
    uv tool install isort
    uv tool install shandy-sqlfmt
}

install_nodejs(){
    fnm install $(fnm ls-remote|tail -n 1)
    fnm use $(fnm ls-remote|tail -n 1)
}

install_rust(){
    if ! type cargo > /dev/null 2>&1 ;then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    else
        echo "Rust already installed."
    fi
}


install_deno(){
    if which deno >>/dev/null 2>&1 ;then
        echo "Deno already installed."
        exit 0
    fi

    curl -fsSL https://deno.land/x/install/install.sh | sh
}


install_go_packages(){
    go install golang.org/x/tools/cmd/goimports@latest
    go install golang.org/x/tools/gopls@latest
    go install github.com/google/yamlfmt/cmd/yamlfmt@latest

    brew install ghq fzf
}


install_rust_tools(){
    source "$HOME/.cargo/env"
    cargo install \
        ripgrep \
        exa \
        bat \
        fd-find \
        starship \
        tree-sitter-cli
}

main(){
    install_uv_tools
    install_nodejs
    install_rust
    install_go_packages
    install_rust_tools
}
