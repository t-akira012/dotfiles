# tate
tmux split-window -v -c '#{pane_current_path}' -p 85
# yoko
tmux split-window -h -c '#{pane_current_path}' -p 80
tmux split-window -h -c '#{pane_current_path}' -p 20

# set
tmux select-pane -t 3
