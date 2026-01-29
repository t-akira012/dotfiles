#!/bin/bash
# tmuxセッション名
SESSION_NAME="Dev"

# セッションが既に存在するかチェック
tmux has-session -t $SESSION_NAME 2>/dev/null

if [ $? \!= 0 ]; then
    # セッションが存在しない場合、新規作成
    
    tmux new-session -d -s $SESSION_NAME -n "dev"
fi

# セッションにアタッチ
tmux attach-session -t $SESSION_NAME
