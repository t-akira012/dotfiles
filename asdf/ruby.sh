#!/usr/bin/env bash
set -e


if ! type ruby >/dev/null 2>&1 ; then
    if type apt; then
        sudo apt update
        sudo apt -y install libssl-dev zlib1g-dev libyaml-0-2 libyaml-dev
    fi

    asdf install ruby latest
    asdf global ruby latest
fi

echo done.
