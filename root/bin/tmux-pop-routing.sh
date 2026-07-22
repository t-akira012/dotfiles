#!/usr/bin/env bash

set -eux

if [[ $(whoami) == 't-akira012' ]];then
    $HOME/bin/tmux-macmini.sh
else
    $HOME/bin/tmux-popup-agents.sh
fi
