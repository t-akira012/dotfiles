@echo off
for /f "delims=" %%d in ('dir /b /ad ^| fzf') do (
    >>"%USERPROFILE%\.dir_history" echo %%~fd
    cd /d "%%d"
)
