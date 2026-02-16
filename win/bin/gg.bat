@echo off
for /f "usebackq delims=" %%i in (`ghq list ^| fzf --preview "type %GOPATH%\ghq\%%i\README.md"`) do (
    cd /d %GOPATH%\ghq\%%i
)
