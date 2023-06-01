#!/usr/bin/env bash
set -eu
echo === Install Rust

if which rustup >>/dev/null 2>&1 ;then
  echo "Rust already installed."
else
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

echo Install rust crates
cargo install \
  rustfmt \
  ripgrep \
  exa \
  bat \
  fd-find \
  zellij

