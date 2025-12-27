#!/bin/bash
set -eux

if [[ ! -e $HOME/iCloud ]];then
    ln -si "$HOME/Library/Mobile Documents/com~apple~CloudDocs/" "$HOME/iCloud"
fi
if [[ ! -e $HOME/Works ]];then
    ln -si "$HOME/Library/Mobile Documents/com~apple~CloudDocs/_Works" "$HOME/Works"
fi
if [[ ! -e $HOME/.ssh ]];then
    ln -si "$HOME/Library/Mobile Documents/com~apple~CloudDocs/.ssh" "$HOME/.ssh"
fi
