#!/usr/bin/env bash
set -eu

if ! type python >/dev/null 2>&1 ; then
    asdf install python latest
    asdf global python latest
fi

echo done.
