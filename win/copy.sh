#!/usr/bin/env bash
set -u

copy_files() {
    local failed=0
    if cp -r ./bin "/mnt/c/Users/${WIN_USERNAME}/"; then
        printf '%s\n' 'Copied bin.'
    else
        printf 'MANUAL: Copy %s/bin to /mnt/c/Users/%s/bin.\n' "$PWD" "$WIN_USERNAME" >&2
        failed=1
    fi

    if [ ! -d "/mnt/c/Users/${WIN_USERNAME}/Tools/keyhac" ]; then
        printf 'MANUAL: Place Keyhac under /mnt/c/Users/%s/Tools/keyhac.\n' "$WIN_USERNAME" >&2
        failed=1
    elif cp ./keyhac/config.py "/mnt/c/Users/${WIN_USERNAME}/Tools/keyhac/config.py"; then
        printf '%s\n' 'Copied Keyhac config.'
    else
        printf 'MANUAL: Copy %s/keyhac/config.py to /mnt/c/Users/%s/Tools/keyhac/config.py.\n' "$PWD" "$WIN_USERNAME" >&2
        failed=1
    fi
    return "$failed"
}

main() {
    if [ ! -f .env ]; then
        printf '%s\n' '.env not found.' >&2
        return 1
    fi
    # shellcheck source=/dev/null
    . ./.env
    if copy_files; then
        printf '%s\n' 'Windows files copied.'
    else
        return 1
    fi
    return 0
}

main "$@"
