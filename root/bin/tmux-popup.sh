#!/bin/bash

# 現在のセッション名を取得
session=$(tmux display-message -p -F "#{session_name}")

# tmux popup windowをトグルする関数
max(){
    # ウィンドウのサイズを設定
    local width='100%'
    local height='100%'

    # セッション名に"popup"が含まれるかチェック
    if [[ $session == *"popup"* ]]; then
        # "popup"が含まれる場合、クライアントをデタッチ（ポップアップを閉じる）
        tmux detach-client
    else
        # "popup"が含まれない場合、新しいポップアップウィンドウを表示
        tmux popup -d '#{pane_current_path}' -xC -yC -w$width -h$height -E "tmux attach -t popup || tmux new -s popup"
    fi
}

right(){
    # ウィンドウのサイズを設定
    local width='50%'
    local height='100%'

    # セッション名に"popup"が含まれるかチェック
    if [[ $session == *"popup"* ]]; then
        # "popup"が含まれる場合、クライアントをデタッチ（ポップアップを閉じる）
        tmux detach-client
    else
        # "popup"が含まれない場合、新しいポップアップウィンドウを表示
        tmux popup -d '#{pane_current_path}' -xR -yC -w$width -h$height -E "tmux attach -t popup || tmux new -s popup"
    fi
}

if [[ "$1" == "right" ]];then
 right &
elif [[ "$1" == "max" ]];then
 max &
fi
