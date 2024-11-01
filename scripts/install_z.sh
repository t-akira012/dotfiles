#!/usr/bin/env bash

[[ ! -d $HOME/.local/bin/ ]] && mkdir -p $HOME/.local/bin/
wget "https://raw.githubusercontent.com/rupa/z/master/z.sh" -O "$HOME/.local/bin/z.sh"
chmod +x $HOME/.local/bin/z.sh
