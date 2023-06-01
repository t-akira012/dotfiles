#!/usr/bin/env bash
set -eu
echo === Download git-completion

export LOCAL_BIN="$HOME/.local/bin"
[[ ! -d "$LOCAL_BIN" ]] && mkdir -p $TARGET

cd $LOCAL_BIN
wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash

chmod +x git-prompt.sh
chmod +x git-completion.bash
