#!/usr/bin/env bash
set -euo pipefail

pack() {
    local src="${1%/}"
    local name
    local parent
    local output

    name="$(basename "$src")"
    parent="$(dirname "$src")"
    output="${name}.tar.zst"

    [ ! -e "$output" ] || {
        echo "already exists: $output" >&2
        exit 1
    }

    tar -C "$parent" -cf - -- "$name" |
        zstd --ultra -22 -T0 -o "$output"
}

unpack() {
    zstd -dc -- "$1" |
        tar -xf -
}

main() {
    [ "$#" -eq 1 ] || {
        echo "usage: tarzst.sh <file|directory|archive.tar.zst>" >&2
        exit 1
    }

    [ -e "$1" ] || {
        echo "not found: $1" >&2
        exit 1
    }

    case "$1" in
        *.tar.zst) unpack "$1" ;;
        *)         pack "$1" ;;
    esac
}

main "$@"
