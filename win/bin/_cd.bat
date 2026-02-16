@echo off
cd /d %*
>>"%USERPROFILE%\.dir_history" echo %CD%
