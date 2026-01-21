#!/usr/bin/env bash
set -eu
#########################################################
echo "=== Create symbolic links"
#########################################################

BASEPATH="$HOME/dotfiles/root"
BACKUP_SUFFIX="$(date +"%Y%m%d_%H%M")"

# ---- utility: safe symlink ----
symlink() {
  local src="$1"
  local dst="$2"

  # ディレクトリ存在保証
  mkdir -p "$(dirname "$dst")"

  # 既存ファイル処理
  if [[ -L "$dst" ]]; then
    echo "[SKIP] $dst (already symlink)"
    return
  elif [[ -e "$dst" ]]; then
    local backup="${dst}.bak.${BACKUP_SUFFIX}"
    mv "$dst" "$backup"
    echo "[BACKUP] $dst -> $backup"
  fi

  # シンボリックリンク作成
  ln -sfn "$src" "$dst"
  echo "[LINK] $src -> $dst"
}

# ---- common links ----
for_all() {
  mkdir -p "$HOME/.config"

  symlink "$BASEPATH/.bashrc" "$HOME/.bashrc"
  symlink "$BASEPATH/.config/zsh" "$HOME/.config/zsh"
  symlink "$BASEPATH/.config/zsh/.zshrc" "$HOME/.zshrc"

  symlink "$BASEPATH/bin" "$HOME/bin"
  symlink "$BASEPATH/.tmux.conf" "$HOME/.tmux.conf"
  symlink "$BASEPATH/.config/git" "$HOME/.config/git"
  symlink "$BASEPATH/.config/starship.toml" "$HOME/.config/starship.toml"
  symlink "$BASEPATH/.config/ghostty" "$HOME/.config/ghostty"
  symlink "$BASEPATH/.config/alacritty" "$HOME/.config/alacritty"
}

# ---- OS specific ----
for_darwin() {
  symlink "$BASEPATH/.config/karabiner" "$HOME/.config/karabiner"
}

for_linux() {
  symlink "$BASEPATH/.config/xremap" "$HOME/.config/xremap"
}

# ---- execute ----
for_all

case "$(uname)" in
  Darwin) for_darwin ;;
  Linux)  for_linux ;;
esac
