#!/usr/bin/env bash
set -eu

if ! type python; then
    # asdf plugin add python
    asdf install python latest
    asdf global python latest
fi

echo done.
