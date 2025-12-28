#!/bin/bash
set -eux

if [[ ! -L $HOME/iCloud ]];then
    ln -si "$HOME/Library/Mobile Documents/com~apple~CloudDocs/" "$HOME/iCloud"
fi
if [[ ! -L $HOME/Works ]];then
    ln -si "$HOME/Library/Mobile Documents/com~apple~CloudDocs/_Works" "$HOME/Works"
fi
if [[ ! -L $HOME/.ssh ]];then
    ln -si "$HOME/Library/Mobile Documents/com~apple~CloudDocs/.ssh" "$HOME/.ssh"
fi

if [[ ! -L $HOME/Downloads ]];then
    ln -si "$HOME/Library/Mobile Documents/com~apple~CloudDocs/_Works/PxDownloader" "$HOME/Downloads/PxDownloader"
fi
