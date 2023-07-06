if [[ $(tmux display -p "#{window_panes}" ) -eq 1 ]];then
    # tate
    tmux split-window -v -c '#{pane_current_path}' -p 85
    # yoko
    tmux split-window -h -c '#{pane_current_path}' -p 80
    tmux split-window -h -c '#{pane_current_path}' -p 20

    # command
    tmux send-key -t 4 "doc-today" C-m

    # select
    tmux select-pane -t 3

else
    echo already tmux has some panes.
fi
