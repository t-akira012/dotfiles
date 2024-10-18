#!/usr/bin/env bash
set -eu

if ! type python >/dev/null 2>&1 ; then
    asdf install python latest
    asdf global python latest
fi

if ! type uv >/dev/null 2>&1 ; then
  # https://docs.astral.sh/uv/#getting-started
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi

echo done.
