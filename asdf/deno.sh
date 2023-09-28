#!/usr/bin/env bash
set -eux

#########################################################
echo Install deno
#########################################################

if which deno >>/dev/null 2>&1 ;then
    echo "Deno already installed."
    exit 0
fi

curl -fsSL https://deno.land/x/install/install.sh | sh

# arm
# curl -s https://gist.githubusercontent.com/LukeChannings/09d53f5c364391042186518c8598b85e/raw/ac8cd8c675b985edd4b3e16df63ffef14d1f0e24/deno_install.sh | sh
