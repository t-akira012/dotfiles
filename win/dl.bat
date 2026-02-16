@echo off
setlocal enabledelayedexpansion

set TEMP_DIR=%TEMP%\dotfiles_%RANDOM%
set ZIP_URL=https://github.com/t-akira012/dotfiles/archive/refs/heads/main.zip

echo Downloading dotfiles ...
mkdir "%TEMP_DIR%" 2>nul
curl -sL "%ZIP_URL%" -o "%TEMP_DIR%\dotfiles.zip"
tar xvf "%TEMP_DIR%\dotfiles.zip" -C "%TEMP_DIR%"

set SRC=%TEMP_DIR%\dotfiles-main\win

echo.
echo Copying bin ...
xcopy /s /y "%SRC%\bin" "%USERPROFILE%\bin\"

echo.
echo Installing keyhac ...
if not exist "%USERPROFILE%\keyhac\keyhac.exe" (
    set "KEYHAC_URL="
    for /f "delims=" %%u in ('powershell -NoProfile -Command "(Invoke-RestMethod 'https://api.github.com/repos/crftwr/keyhac-win/releases/latest').assets[0].browser_download_url"') do set "KEYHAC_URL=%%u"
    if defined KEYHAC_URL (
        echo   !KEYHAC_URL!
        curl -sL "!KEYHAC_URL!" -o "%TEMP_DIR%\keyhac.zip"
        tar xvf "%TEMP_DIR%\keyhac.zip" -C "%USERPROFILE%"
        echo   -^> %USERPROFILE%\keyhac
    ) else (
        echo   ERROR: asset not found
    )
) else (
    echo   SKIP: keyhac already exists
)

echo.
echo Copying keyhac\config.py ...
copy /y "%SRC%\keyhac\config.py" "%USERPROFILE%\keyhac\config.py"

echo.
echo Running install.bat ...
call "%SRC%\exe\install.bat"

rd /s /q "%TEMP_DIR%"
echo.
echo All done!
