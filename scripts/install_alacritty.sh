#!/usr/bin/env bash
cargo install alacritty
cd $HOME
mkdir alacritty
wget https://raw.githubusercontent.com/alacritty/alacritty/refs/heads/master/extra/logo/alacritty-term.svg
sudo cp alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
wget https://raw.githubusercontent.com/alacritty/alacritty/refs/heads/master/extra/linux/Alacritty.desktop
chmod 755 Alacritty.desktop
sudo ln -s /home/aki/.cargo/bin/alacritty /usr/local/bin/alacritty
sudo desktop-file-install Alacritty.desktop
sudo update-desktop-database
