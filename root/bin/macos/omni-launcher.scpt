tell application "Ghostty"
	activate
	repeat until frontmost
		delay 0.05
	end repeat
end tell
do shell script "/opt/homebrew/bin/tmux run-shell '$HOME/bin/omni/omni'"
