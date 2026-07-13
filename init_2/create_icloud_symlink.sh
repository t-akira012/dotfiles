#!/bin/bash
set -eux

# TODO:
# EXTERNAL_SSD_PATH=/Volumes/ssd
#
# if [[ ! -L $HOME/Downloads/PxDownloader/ ]];then
#     ln -si "${EXTERNAL_SSD_PATH}/archives/PxDownloader" "$HOME/Downloads/PxDownloader"
# fi
#
# if [[ ! -L $HOME/Works ]];then
#     ln -si "${EXTERNAL_SSD_PATH}/nextcloud/mirror/Works" "$HOME/Works"
# fi


if [[ $(whoami) != t-akira012 ]]; then
    echo "user is not t-akira012"
fi

if [[ ! -L $HOME/iCloud ]];then
    ln -si "$HOME/Library/Mobile Documents/com~apple~CloudDocs/" "$HOME/iCloud"
fi
if [[ ! -L $HOME/.ssh ]];then
    ln -si "$HOME/Library/Mobile Documents/com~apple~CloudDocs/.ssh" "$HOME/.ssh"
fi

if [[ ! -L $HOME/Downloads ]];then
    ln -si "$HOME/Library/Mobile Documents/com~apple~CloudDocs/_Works/PxDownloader" "$HOME/Downloads/PxDownloader"
fi

mkdir $HOME/docs
if [[ ! -L $HOME/docs/doc ]];then
    ln -si "$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/memo" "$HOME/docs/doc"
fi
