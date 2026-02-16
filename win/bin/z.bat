@echo off
for /f "delims=" %%d in ('sort /unique "%USERPROFILE%\.dir_history" ^| fzf') do cd /d "%%d"
