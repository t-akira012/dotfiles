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
