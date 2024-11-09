#!/usr/bin/env bash
wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
sudo apt install -y ./chrome-remote-desktop_current_amd64.deb
sudo apt -y autoremove
rm -rf chrome-remote-desktop_current_amd64.deb
mkdir ~/.config/chrome-remote-desktop

