@echo off
set "FZF_QUERY="
if not "%~1"=="" set "FZF_QUERY=-q %*"
for /f "delims=" %%f in ('rg --files --follow --no-ignore-vcs --hidden -g "!{node_modules/*,.git/*}" ^| sort ^| fzf %FZF_QUERY%') do nvim "%%f"
