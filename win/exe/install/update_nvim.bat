@echo off
setlocal
chcp 65001 >nul

set "TEMP_DIR=%USERPROFILE%\Downloads\tmp\nvim_update_%RANDOM%"
set ZIP_URL=https://github.com/t-akira012/kickstart.nvim/archive/refs/heads/main.zip
set DEST=%USERPROFILE%\.config\nvim

echo kickstart.nvim をダウンロードしています...
mkdir "%TEMP_DIR%" 2>nul
if errorlevel 1 goto :fail
curl -fL "%ZIP_URL%" -o "%TEMP_DIR%\nvim.zip"
if errorlevel 1 goto :fail
tar xvf "%TEMP_DIR%\nvim.zip" -C "%TEMP_DIR%"
if errorlevel 1 goto :fail
if not exist "%TEMP_DIR%\kickstart.nvim-main\" goto :fail

echo.
echo %DEST% を更新しています...
if exist "%DEST%\" (
    echo 既存の Neovim 設定を削除しています...
    rd /s /q "%DEST%"
    if errorlevel 1 goto :fail
)
mkdir "%DEST%"
if errorlevel 1 goto :fail
xcopy /s /e /y "%TEMP_DIR%\kickstart.nvim-main\*" "%DEST%\"
if errorlevel 1 goto :fail

rd /s /q "%TEMP_DIR%"
echo.
echo Neovim 設定の更新が完了しました。
exit /b 0

:fail
echo エラー: Neovim 設定の更新に失敗しました。
if exist "%TEMP_DIR%\kickstart.nvim-main\" echo 手動: "%TEMP_DIR%\kickstart.nvim-main" を "%DEST%" にコピーしてください。
if exist "%TEMP_DIR%\nvim.zip" echo         ZIP: "%TEMP_DIR%\nvim.zip"
exit /b 1
