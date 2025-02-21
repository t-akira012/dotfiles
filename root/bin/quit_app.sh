#!/bin/bash
# 除外したいアプリケーション名を配列で指定
excludedApps=("iTerm2" "Notion" "Finder")

# AppleScriptで、背景アプリ以外のプロセス一覧を取得
appList=$(osascript -e 'tell application "System Events" to get name of every process whose background only is false')
IFS=$'\n' read -rd '' -a apps <<< "$(echo "$appList" | tr ',' '\n')"

# 各アプリケーションをループし、除外リストに含まれていないアプリを終了
for app in "${apps[@]}"; do
    # 前後の空白を除去
    app=$(echo "$app" | sed 's/^ *//; s/ *$//')
    skip=false
    for exclude in "${excludedApps[@]}"; do
        if [ "$app" = "$exclude" ]; then
            skip=true
            break
        fi
    done
    if [ "$skip" = false ]; then
        echo "Quitting: $app"
        osascript -e "tell application \"$app\" to quit" 2>/dev/null
    fi
done
