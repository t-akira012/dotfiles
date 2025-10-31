#!/bin/zsh
# https://sushichan044.hateblo.jp/entry/2025/06/06/003325
# fzf-based git worktree selector
# Inspired by:
# - https://www.mizdra.net/entry/2024/10/19/172323 (git branch selection patterns)
#
# Usage:
#   - Direct: fzf-worktree
#   - Keybind: Ctrl+N
#
# Features:
#   - Lists all git worktrees with enhanced preview
#   - Shows git log in preview pane
#   - Works both from command line and as ZLE widget
# Prerequisites:
#   - git
#   - fzf
#   - zsh

function fzf-worktree() {
    # Format of `git worktree list`: path commit [branch]
    local selected_worktree=$(git worktree list | sed "s|$HOME|~|g" | fzf \
        --prompt="worktrees > " \
        --header="Select a worktree to cd into" \
        --preview="echo '📦 Branch:' && git -C {1} branch --show-current && echo '' && echo '📝 Changed files:' && git -C {1} status --porcelain | head -10 && echo '' && echo '📚 Recent commits:' && git -C {1} log --oneline --decorate -10" \
        --preview-window="right:40%" \
        --reverse \
        --border \
        --ansi)

    if [ $? -ne 0 ]; then
        return 0
    fi

    if [ -n "$selected_worktree" ]; then
        local selected_path=${${(s: :)selected_worktree}[1]}
        selected_path=${selected_path/#\~/$HOME}

        if [ -d "$selected_path" ]; then
            if zle; then
                # Called from ZLE (keyboard shortcut)
                BUFFER="cd ${selected_path}"
                zle accept-line
            else
                # Called directly from command line
                cd "$selected_path"
            fi
        else
            echo "Directory not found: $selected_path"
            return 1
        fi
    fi

    # Only clear screen if ZLE is active
    if zle; then
        zle clear-screen
    fi
}

function fzf-worktree-add() {
    local branch=$(git branch -a --format='%(refname:short)' | fzf --prompt="branch > ")
    [ -z "$branch" ] && return 0

    local remote=$(git remote get-url origin)
    local platform=$(echo $remote | grep -oE '(@|://)[^/:]+' | cut -d@ -f2 | cut -d: -f3)
    local owner_repo=$(echo $remote | grep -oE '[^/:]+/[^/]+$' | cut -d. -f1)
    local timestamp=$(date +%Y%m%d%H%M%S)

    local worktree_path="$HOME/worktree/$platform/$owner_repo/${branch}_$timestamp"

    git worktree add "$worktree_path" "$branch" && cd "$worktree_path"
}

alias gw=fzf-worktree
alias gwa=fzf-worktree-add
