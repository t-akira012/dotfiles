#!/usr/bin/env bash
echo "=== Install Clipper"
brew install clipper
echo "=== Start Clipper service"
brew services start clipper

echo "=== Create clipper json"
cat <<EOF > $HOME/.clipper.json
{
  "address": "~/.clipper.sock"
}
EOF

echo "=== Check"
brew services
cat $HOME/.clipper.json
