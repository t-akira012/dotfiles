@echo off
setlocal

set "TEMP_DIR=%USERPROFILE%\Downloads\tmp\nvim_update_%RANDOM%"
set ZIP_URL=https://github.com/t-akira012/kickstart.nvim/archive/refs/heads/main.zip
set DEST=%USERPROFILE%\.config\nvim

echo Downloading kickstart.nvim ...
mkdir "%TEMP_DIR%" 2>nul
if errorlevel 1 goto :fail
curl -fL "%ZIP_URL%" -o "%TEMP_DIR%\nvim.zip"
if errorlevel 1 goto :fail
tar xvf "%TEMP_DIR%\nvim.zip" -C "%TEMP_DIR%"
if errorlevel 1 goto :fail
if not exist "%TEMP_DIR%\kickstart.nvim-main\" goto :fail

echo.
echo Updating %DEST% ...
if exist "%DEST%\" (
    echo Removing existing Neovim config ...
    rd /s /q "%DEST%"
    if errorlevel 1 goto :fail
)
mkdir "%DEST%"
if errorlevel 1 goto :fail
xcopy /s /e /y "%TEMP_DIR%\kickstart.nvim-main\*" "%DEST%\"
if errorlevel 1 goto :fail

rd /s /q "%TEMP_DIR%"
echo.
echo Done!
exit /b 0

:fail
echo ERROR: Neovim config update failed.
if exist "%TEMP_DIR%\kickstart.nvim-main\" echo MANUAL: Copy "%TEMP_DIR%\kickstart.nvim-main" to "%DEST%".
if exist "%TEMP_DIR%\nvim.zip" echo         ZIP: "%TEMP_DIR%\nvim.zip"
exit /b 1
