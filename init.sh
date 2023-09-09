#!/usr/bin/env bash
set -eu
cd $(dirname $0)

_for_ubuntu(){
    if type apt;then
        sudo apt update
        # require brew
        sudo apt install git
        # requre for cargo build
        sudo apt install -y build-essential
        # require tmux copy
        sudo apt install -y xsel
    fi
    mv "$HOME/.bashrc" "$HOME/.bashrc.bak.$(date +"%Y%m%d_%H%M")"
}

_for_mac(){
    if [[ $(uname) == "Darwin" ]];then
        echo "[ -f ~/.bashrc ] && . ~/.bashrc" >> $HOME/.bash_profile

        echo '=== Install packages for macOS'
        brew install \
            gnu-sed \
            gawk \
            coreutils \
            binutils \
            findutils \
            util-linux \

        echo '=== Install cask packages'
        brew install --cask google-chrome
        brew install --cask visual-studio-code
        brew install --cask coteditor
        brew install --cask iterm2
        brew install --cask karabiner-elements
        brew install --cask alfred
        brew install --cask rectangle
        brew install --cask alt-tab
        brew install --cask slack

        brew tap homebrew/cask-fonts
        brew install font-plemol-jp
        brew install font-plemol-jp-nf
        brew install font-plemol-jp-hs
        brew install font-hackgen font-hackgen-nerd
    fi
}

_for_ubuntu

#########################################################
echo Install Homebrew
#########################################################

_eval_brew(){
    if [[ -e /opt/homebrew/bin/brew ]];then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif test -d /home/linuxbrew >>/dev/null 2>&1 ;then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    else
        echo 'You must install linuxbrew.'
    fi
}

_eval_brew
if which brew >>/dev/null 2>&1 ;then
    echo "Homebrew already installed."
else
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    _eval_brew
fi

#########################################################
echo Install Homebrew packages
#########################################################

brew install \
    git \
    gh \
    curl \
    wget \
    tree \
    tmux \
    watch \
    expect \
    z \
    unar \
    nvim \
    shfmt \

#########################################################
echo "Add git config"
#########################################################

git config --global ghq.root ~/src
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.l "log --graph"
git config --global alias.dfc "diff --cached"
git config --global pull.rebase false
git config --global diff.tool vimdiff
git config --global difftool.prompt false
git config --global diff.colorMoved dimmed-zebra
git config --global diff.colorMovedWS allow-indentation-change
git config --global grep.lineNumber true
git config --global core.quotepath false

#########################################################
echo Create symbolic links
#########################################################

BASEPATH=$HOME/dotfiles/root
[[ ! -d $HOME/.config ]] && mkdir $HOME/.config
ln -si $BASEPATH/bin $HOME/bin
ln -si $BASEPATH/.tmux.conf $HOME/.tmux.conf
ln -si $BASEPATH/.config/git $HOME/.config/git
ln -si $BASEPATH/.bashrc $HOME/.bashrc

#########################################################
echo Install Go
#########################################################

if which go >>/dev/null 2>&1 ;then
    echo "Go already installed."
else
    brew install go
    go version
fi

#########################################################
echo Install Go packages
#########################################################
brew install fzf ghq
go install golang.org/x/tools/cmd/goimports@latest
go install golang.org/x/tools/gopls@latest
go install github.com/google/yamlfmt/cmd/yamlfmt@latest


#########################################################
echo Install Rust
#########################################################

if which rustup >>/dev/null 2>&1 ;then
    echo "Rust already installed."
else
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

#########################################################
echo Install rust tools
#########################################################
source "$HOME/.cargo/env"
cargo install \
    ripgrep \
    exa \
    bat \
    fd-find

#########################################################
echo Install deno
#########################################################

echo Install deno

if which deno >>/dev/null 2>&1 ;then
    echo "Deno already installed."
else
    curl -fsSL https://deno.land/x/install/install.sh | sh
fi

#########################################################
echo Download git-completion
#########################################################


export LOCAL_BIN="$HOME/.local/bin"
[[ ! -d "$LOCAL_BIN" ]] && mkdir -p $LOCAL_BIN

cd $LOCAL_BIN
curl -o https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
curl -o https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash

chmod +x git-prompt.sh
chmod +x git-completion.bash

#########################################################
echo kickstart.nvim
#########################################################

if which ghq >>/dev/null 2>&1 ;then
    ghq get t-akira012/kickstart.nvim
    ln -si $(ghq root)/github.com/t-akira012/kickstart.nvim $HOME/.config/nvim
else
    echo "require ghq"
fi

#########################################################
echo Create w3m config
#########################################################


if [[ ! -d "$HOME/.w3m" ]];then
    mkdir "$HOME/.w3m"
fi

[[ ! -f $HOME/.w3m/config ]] && touch "$HOME/.w3m/config"
echo "extbrowser /usr/bin/open" >> "$HOME/.w3m/config"

#########################################################
echo Create ~/.ex
#########################################################


cat <<EOF >> $HOME/.ex
# export OPENAI_API_KEY=''
# export PATH=""
# export GIST_DIR=""
# export MEMO_DIR=""
# export BOOKMARKS_DIR=""
#
# colors
# export TERM_COLOR_MODE='DARK'
# export NVIM_COLOR_DARK='tokyonight'
# export NVIM_COLOR_LIGHT='tokyonight-day'
# export ZELLIJ_COLOR_DARK='tokyonight'
# export ZELLIJ_COLOR_LIGHT='pencil-light'
EOF

_for_mac

echo initialize done.
