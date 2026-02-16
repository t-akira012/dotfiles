#!/usr/bin/env bash
set -u
source .env
rm -rf /mnt/c/Users/${WIN_USERNAME}/bin
cp -r ./bin /mnt/c/Users/${WIN_USERNAME}/
