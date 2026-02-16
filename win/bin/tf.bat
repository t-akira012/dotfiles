@echo off
set "DEPTH=%~1"
if "%DEPTH%"=="" set "DEPTH=9"
for /f "delims=" %%d in ('fd --type d --hidden --max-depth %DEPTH% --exclude node_modules --exclude .git ^| fzf') do cd /d "%%d"
