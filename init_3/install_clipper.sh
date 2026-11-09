#!/usr/bin/env bash
set -eu
echo "=== Install Clipper"
brew install clipper

echo "=== Create clipper json"
cat <<EOF > "$HOME/.clipper.json"
{
  "address": "~/.clipper.sock"
}
EOF

echo "=== Start Clipper service"
brew services start clipper

echo "=== Check"
brew services list
cat "$HOME/.clipper.json"
