#!/usr/bin/env bash

sudo pacman -Syy

# 日本語入力
sudo pacman -S manjaro-asian-input-support-ibus fcitx-mozc gtk2

# ホームディレクトリの英語化
sudo pacman -S xdg-user-dirs-gtk
LC_ALL=C xdg-user-dirs-gtk-update
