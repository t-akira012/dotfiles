@echo off
chcp 65001
if not exist "%USERPROFILE%\bin\paths.txt" (
    echo ERROR: Missing "%USERPROFILE%\bin\paths.txt". Run dl.bat again.
    exit /b 1
)
for /f "usebackq delims=" %%p in ("%USERPROFILE%\bin\paths.txt") do call :add_path "%%p"
set XDG_CONFIG_HOME=%USERPROFILE%\.config
doskey /macrofile=%USERPROFILE%\bin\init.macros
cmd.exe
exit /b %ERRORLEVEL%

:add_path
set "PATH=%PATH%;%USERPROFILE%\%~1"
exit /b
