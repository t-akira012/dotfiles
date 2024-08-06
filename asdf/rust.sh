#!/usr/bin/env bash
set -eux

#########################################################
echo Install Rust
#########################################################
#
if ! type rustup > /dev/null 2>&1 ;then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
else
    echo "Rust already installed."
fi
