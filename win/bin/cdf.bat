@echo off
for /f "delims=" %%d in ('dir /b /ad ^| fzf') do cd /d "%%d"
