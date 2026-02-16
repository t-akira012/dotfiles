@echo off
for /f "delims=" %%d in ('git rev-parse --show-toplevel 2^>nul') do cd /d "%%d" & exit /b
echo not git repo
