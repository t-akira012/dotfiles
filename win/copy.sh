#!/usr/bin/env bash
set -u

copy_files() {
    if cp -r ./bin "/mnt/c/Users/${WIN_USERNAME}/"; then
        printf '%s\n' 'Copied bin.'
    else
        printf '%s\n' 'Failed to copy bin.' >&2
        return 1
    fi

    if [ ! -d "/mnt/c/Users/${WIN_USERNAME}/Tools/keyhac" ]; then
        printf '%s\n' 'Keyhac 2 is not installed under Tools/keyhac.' >&2
        return 1
    fi
    if cp ./keyhac/config.py "/mnt/c/Users/${WIN_USERNAME}/Tools/keyhac/config.py"; then
        printf '%s\n' 'Copied Keyhac config.'
    else
        printf '%s\n' 'Failed to copy Keyhac config.' >&2
        return 1
    fi
    return 0
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
