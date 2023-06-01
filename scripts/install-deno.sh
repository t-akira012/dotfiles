#!/usr/bin/env bash
set -eu
echo === Install deno

if which deno >>/dev/null 2>&1 ;then
  echo "Deno already installed."
else
  curl -fsSL https://deno.land/x/install/install.sh | sh
fi
