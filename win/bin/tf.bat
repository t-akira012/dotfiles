@echo off
set "DEPTH=%~1"
if "%DEPTH%"=="" set "DEPTH=9"
for /f "delims=" %%d in ('eza -Da -R -L %DEPTH% -I node_modules -I .git ^| fzf') do cd /d "%%d"
