#!/bin/bash
# tmuxセッション名
SESSION_NAME="iTerm"

# セッションが既に存在するかチェック
tmux has-session -t $SESSION_NAME 2>/dev/null

if [ $? \!= 0 ]; then
    # セッションが存在しない場合、新規作成
    
    tmux new-session -d -s $SESSION_NAME -n "f"
    tmux new-window -t $SESSION_NAME:2 -n "dev"
    tmux new-window -t $SESSION_NAME:3 -n "doc"
    tmux new-window -t $SESSION_NAME:8 -n "env"
    tmux new-window -t $SESSION_NAME:9 -n "doc" -c $HOME/docs/doc/
    
    # 最初のウィンドウを選択
    tmux select-window -t $SESSION_NAME:1
fi

# セッションにアタッチ
tmux attach-session -t $SESSION_NAME
