@echo off
setlocal enabledelayedexpansion

set TEMP_DIR=%TEMP%\dotfiles_%RANDOM%
set ZIP_URL=https://github.com/t-akira012/dotfiles/archive/refs/heads/main.zip

echo Downloading dotfiles ...
mkdir "%TEMP_DIR%" 2>nul
curl -sL "%ZIP_URL%" -o "%TEMP_DIR%\dotfiles.zip"
tar xvf "%TEMP_DIR%\dotfiles.zip" -C "%TEMP_DIR%"

set SRC=%TEMP_DIR%\dotfiles-main\win
set KEYHAC_DIR=%USERPROFILE%\exe\keyhac

echo.
echo Copying bin ...
xcopy /s /y "%SRC%\bin" "%USERPROFILE%\bin\"

echo.
echo Copying googleime\keybind.txt ...
mkdir "%USERPROFILE%\.config\googleime" 2>nul
copy /y "%SRC%\googleime\keybind.txt" "%USERPROFILE%\.config\googleime\keybind.txt"
if errorlevel 1 goto :fail

echo.
echo Installing keyhac ...
mkdir "%USERPROFILE%\exe" 2>nul
if not exist "%KEYHAC_DIR%\keyhac.exe" (
    set "KEYHAC_URL="
    for /f "delims=" %%u in ('powershell -NoProfile -Command "(Invoke-RestMethod 'https://api.github.com/repos/crftwr/keyhac-win/releases/latest').assets | Where-Object { $_.name -like 'keyhac_*.zip' } | Select-Object -First 1 -ExpandProperty browser_download_url"') do set "KEYHAC_URL=%%u"
    if defined KEYHAC_URL (
        echo   !KEYHAC_URL!
        curl -fL "!KEYHAC_URL!" -o "%TEMP_DIR%\keyhac.zip"
        if errorlevel 1 (
            echo   ERROR: keyhac download failed
        ) else (
            tar xvf "%TEMP_DIR%\keyhac.zip" -C "%USERPROFILE%\exe"
            if errorlevel 1 (
                echo   ERROR: keyhac extraction failed
            ) else (
                echo   -^> %KEYHAC_DIR%
            )
        )
    ) else (
        echo   ERROR: asset not found
    )
) else (
    echo   SKIP: keyhac already exists
)

echo.
echo Copying keyhac\config.py ...
if not exist "%KEYHAC_DIR%\keyhac.exe" (
    echo   ERROR: keyhac.exe not found; config.py was not copied
    goto :fail
)
copy /y "%SRC%\keyhac\config.py" "%KEYHAC_DIR%\config.py"
if errorlevel 1 goto :fail

echo.
echo Copying install_exefiles.bat ...
copy /y "%SRC%\exe\install_exefiles.bat" "%USERPROFILE%\exe\install_exefiles.bat"

echo.
echo Copying winget\install_apps.bat ...
mkdir "%USERPROFILE%\exe\winget" 2>nul
copy /y "%SRC%\exe\winget\install_apps.bat" "%USERPROFILE%\exe\winget\install_apps.bat"
if errorlevel 1 goto :fail

echo.
echo Running install_exefiles.bat ...
call "%USERPROFILE%\exe\install_exefiles.bat"

rd /s /q "%TEMP_DIR%"
echo.
echo All done!
exit /b 0

:fail
rd /s /q "%TEMP_DIR%"
echo.
echo Installation failed.
exit /b 1
