#!/usr/bin/env bash

cat <<EOF > $HOME/.clipper.json
{
  "address": "~/.clipper.sock"
}
EOF

brew install clipper
brew services start clipper
