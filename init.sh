#!/usr/bin/env bash
set -eu
cd $(dirname $0)

if type apt ;then
    sudo apt update && \
        sudo apt install -y \
        git build-essential coreutils \
        gh curl wget tree tmux watch expect unar shfmt xsel
    mv "$HOME/.bashrc" "$HOME/.bashrc.bak.$(date +"%Y%m%d_%H%M")"
    bash -c ./_brew.sh
fi

if [[ $(uname) == "Darwin" ]];then
    echo "[ -f ~/.bashrc ] && . ~/.bashrc" >> $HOME/.bash_profile
    bash -c ./_brew.sh
fi

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

echo initialize done.
