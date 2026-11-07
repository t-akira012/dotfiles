@echo off
setlocal

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install_plemoljp_nf.ps1"
exit /b %ERRORLEVEL%
