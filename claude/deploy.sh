#!/usr/bin/env bash -eux
cd $(dirname $0)

files=(CLAUDE.md CLAUDE.ref.md settings.json commands)

for item in "${files[@]}"; do
    ln -si "$PWD/$item" $HOME/.claude/$item
done
