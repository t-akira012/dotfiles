#!/usr/bin/env bash
# create socat pbcopy
echo "socat - UNIX-CLIENT:/home/$(whoami)/.clipper.sock" | sudo tee /usr/local/bin/pbcopy
sudo chmod +x /usr/local/bin/pbcopy
