@echo off
setlocal enabledelayedexpansion

set TEMP_DIR=%TEMP%\nvim_update_%RANDOM%
set ZIP_URL=https://github.com/t-akira012/kickstart.nvim/archive/refs/heads/main.zip
set DEST=%USERPROFILE%\.config\nvim

echo Downloading kickstart.nvim ...
mkdir "%TEMP_DIR%" 2>nul
curl -sL "%ZIP_URL%" -o "%TEMP_DIR%\nvim.zip"
tar xvf "%TEMP_DIR%\nvim.zip" -C "%TEMP_DIR%"

echo.
echo Updating %DEST% ...
rd /s /q "%DEST%" 2>nul
mkdir "%DEST%" 2>nul
xcopy /s /e /y "%TEMP_DIR%\kickstart.nvim-main\*" "%DEST%\"

rd /s /q "%TEMP_DIR%"
echo.
echo Done!
