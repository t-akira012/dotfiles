#!/usr/bin/env bash

set -eux

if [[ $(whoami) == 't-akira012' ]];then
    $HOME/bin/tmux-popup-mini.sh
else
    $HOME/bin/tmux-popup-agents.sh
fi
