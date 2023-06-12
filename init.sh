#!/usr/bin/env bash
set -eu
cd $(dirname $0)

if [[ "$SHELL" != *zsh ]];then
  [[ $(uname) == "Darwin" ]] && chsh -s $(which zsh)
fi

#########################################################
# homebrew
#########################################################
echo === Install Homebrew

_eval_brew(){
  if [[ -e /opt/homebrew/bin/brew ]];then
      eval "$(/opt/homebrew/bin/brew shellenv)"
  elif test -d ~/.linuxbrew >>/dev/null 2>&1 ;then
    eval "$(~/.linuxbrew/bin/brew shellenv)"
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

echo ===  Install Homebrew packages

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
  coreutils \
  binutils \
  findutils \
  gnu-sed \
  gawk \
  shfmt \

brew tap homebrew/cask-fonts \
  && brew install font-hackgen font-hackgen-nerd

#########################################################
# Create symbolic links
#########################################################


echo ===  Create symbolic links
BASEPATH=$HOME/dotfiles/root

[[ ! -d $HOME/.config ]] && mkdir $HOME/.config

ln -si $BASEPATH/bin $HOME/bin

ln -si $BASEPATH/.tmux.conf $HOME/.tmux.conf

ln -si $BASEPATH/.config/git $HOME/.config/git
ln -si $BASEPATH/.config/zsh $HOME/.config/zsh
ln -si $BASEPATH/.config/zellij $HOME/.config/zellij

ln -si $BASEPATH/.bashrc $HOME/.bashrc
ln -si $BASEPATH/.config/zsh/.zshrc $HOME/.zshrc

#########################################################
# Go
#########################################################
echo === Install Go

if which go >>/dev/null 2>&1 ;then
  echo "Go already installed."
else
  brew install go \
    && go version
fi

echo === Install Go packages
brew install fzf ghq
go install golang.org/x/tools/cmd/goimports@latest
go install golang.org/x/tools/gopls@latest
go install github.com/google/yamlfmt/cmd/yamlfmt@latest


#########################################################
# Rust
#########################################################
echo === Install Rust

if which rustup >>/dev/null 2>&1 ;then
  echo "Rust already installed."
else
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

echo Install rust tools
source "$HOME/.cargo/env"
cargo install \
  ripgrep \
  exa \
  bat \
  fd-find \
  zellij

#########################################################
# deno
#########################################################

echo === Install deno

if which deno >>/dev/null 2>&1 ;then
  echo "Deno already installed."
else
  curl -fsSL https://deno.land/x/install/install.sh | sh
fi

#########################################################
# git-completion
#########################################################

echo === Download git-completion

export LOCAL_BIN="$HOME/.local/bin"
[[ ! -d "$LOCAL_BIN" ]] && mkdir -p $LOCAL_BIN

cd $LOCAL_BIN
wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash

chmod +x git-prompt.sh
chmod +x git-completion.bash

#########################################################
# zsh tools
#########################################################

echo === Clone zsh function

[[ ! -d ~/.config/zsh ]] && \
  echo "zsh config directory not found" && \
  exit 1

cd $HOME/.config/zsh

[[ ! -d repos ]] && mkdir repos
[[ ! -d zfunc ]] && mkdir zfunc

cd $HOME/.config/zsh/repos

git clone https://github.com/zsh-users/zsh-syntax-highlighting --depth 1
git clone https://github.com/zsh-users/zsh-autosuggestions --depth 1
git clone https://github.com/zsh-users/zsh-completions --depth 1
git clone https://github.com/intelfx/pure --depth 1
git clone https://github.com/ohmyzsh/ohmyzsh --depth 1
git clone https://github.com/Tarrasch/zsh-bd --depth 1

# pure install
cd $HOME/.config/zsh/repos/pure
ln -s "$PWD/pure.zsh" $HOME/.config/zsh/zfunc/prompt_pure_setup
ln -s "$PWD/async.zsh" $HOME/.config/zsh/zfunc/async

# create .zshrc-ex
cat <<EOF >> $HOME/.zshrc-ex
# export OPENAI_API_KEY=''
# export PATH=""
# export GIST_DIR=""
# export MEMO_DIR=""
# export BOOKMARKS_DIR=""
# export TERM_COLOR_MODE='LIGHT'
EOF

#########################################################
# kickstart.nvim
#########################################################

if which ghq >>/dev/null 2>&1 ;then
  echo === install kickstart.nvim
  ghq get -p t-akira012/kickstart.nvim
  ln -si $(ghq root)/github.com/t-akira012/kickstart.nvim $HOME/.config/nvim
else
  echo "require ghq"
fi

#########################################################
# git config
#########################################################

echo === git config
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

#########################################################
# create w3m config
#########################################################

if [[ ! -d "$HOME/.w3m" ]];then
  mkdir "$HOME/.w3m"
fi

[[ ! -f $HOME/.w3m/config ]] && touch "$HOME/.w3m/config"
echo "extbrowser /usr/bin/open" >> "$HOME/.w3m/config"

#########################################################
# cask packages
#########################################################

if [[ $(uname) == "Darwin" ]];then
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
fi

echo initialize done.
