#!/bin/bash

# tmux popup windowをトグルする関数
function tmuxpopup(){
    # ウィンドウのサイズを設定
    width='90%'
    height='80%'

    # 現在のセッション名を取得
    session=$(tmux display-message -p -F "#{session_name}")

    # セッション名に"popup"が含まれるかチェック
    if [[ $session == *"popup"* ]]; then
    # "popup"が含まれる場合、クライアントをデタッチ（ポップアップを閉じる）
    tmux detach-client
    else
    # "popup"が含まれない場合、新しいポップアップウィンドウを表示
    tmux popup -d '#{pane_current_path}' -xC -yC -w$width -h$height "tmux attach -t popup || tmux new -s popup"
    fi
}

tmuxpopup &
