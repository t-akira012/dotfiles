@echo off
for /f "usebackq delims=" %%i in (`ghq list ^| fzf --preview "bat %USERPROFILE%\ghq\%%i\README.md"`) do (
  gh repo view --web %%i
)
