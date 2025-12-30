#!/bin/bash
set -eux

EXTERNAL_SSD_PATH=/Volumes/ssd

if [[ ! -L $HOME/Downloads/PxDownloader/ ]];then
    ln -si "${EXTERNAL_SSD_PATH}/archives/PxDownloader" "$HOME/Downloads/PxDownloader"
fi

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
