@echo off
set "DEPTH=%~1"
if "%DEPTH%"=="" set "DEPTH=9"
for /f "delims=" %%d in ('tree -i -d -n -N -L %DEPTH% -f -a -I node_modules -I .git ^| fzf') do cd /d "%%d"
