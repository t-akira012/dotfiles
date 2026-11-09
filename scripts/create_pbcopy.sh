#!/usr/bin/env bash
# https://github.com/wincent/clipper を使って macOS と ssh 先の linux 端末で pbcopy を再現する
echo "socat - UNIX-CLIENT:/home/$(whoami)/.clipper.sock" | sudo tee /usr/local/bin/pbcopy
sudo chmod +x /usr/local/bin/pbcopy
