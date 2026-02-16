@echo off
for /f "usebackq delims=" %%i in (`ghq list ^| fzf --preview "type %USERPROFILE%\ghq\%%i\README.md"`) do (
    cd /d %USERPROFILE%\ghq\%%i
)
