#!/usr/bin/env bash
# 日本語入力
sudo pacman -Syy
sudo pacman -S manjaro-asian-input-support-ibus gtk2 fcitx5 fcitx5-configtool fcitx5-mozc fcitx5-im

# ホームディレクトリの英語化
sudo pacman -S xdg-user-dirs-gtk
LC_ALL=C xdg-user-dirs-gtk-update
