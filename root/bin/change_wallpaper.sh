#!/bin/bash

log_file="$HOME/.tmp_wallpaper"
target_wallpaper="$HOME/Documents/3024-4032-max.jpg"
default_wallpaper="/System/Library/Desktop Pictures/Big Sur Night Succulents.madesktop"

# ログファイルから現在の壁紙を取得 (なければデフォルトとみなす)
current_wallpaper=$(cat "$log_file" 2>/dev/null || echo "$default_wallpaper")

echo "ログファイルから読み取った現在の壁紙: \"$current_wallpaper\""
echo "比較対象の壁紙: \"$target_wallpaper\""

if [[ "$current_wallpaper" == "$target_wallpaper" ]]; then
  osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$default_wallpaper\""
  echo "壁紙を $default_wallpaper に変更しました。"
  echo "$default_wallpaper" > "$log_file"
else
  osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$target_wallpaper\""
  echo "壁紙を $target_wallpaper に変更しました。"
  echo "$target_wallpaper" > "$log_file"
fi
