#!/usr/bin/env bash

[[ !-e $HOME/.ssh ]] && mkdir $HOME/.ssh

# サスペンド無効化
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# ssh 有効化
sudo pacman -S openssh
sudo systemctl restart sshd
sudo systemctl enable sshd

