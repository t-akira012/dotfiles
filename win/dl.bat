@echo off
setlocal

set "TEMP_DIR=%USERPROFILE%\Downloads\tmp\dotfiles_%RANDOM%"
set "ZIP_URL=https://github.com/t-akira012/dotfiles/archive/refs/heads/main.zip"
set "NEEDS_MANUAL=0"

echo Downloading dotfiles ...
mkdir "%TEMP_DIR%" 2>nul
if errorlevel 1 goto :fail
curl -fL "%ZIP_URL%" -o "%TEMP_DIR%\dotfiles.zip"
if errorlevel 1 goto :fail
tar xvf "%TEMP_DIR%\dotfiles.zip" -C "%TEMP_DIR%"
if errorlevel 1 goto :fail

set "SRC=%TEMP_DIR%\dotfiles-main\win"
set "KEYHAC_DIR=%USERPROFILE%\Tools\keyhac"
set "CLISM_DIR=%USERPROFILE%\Tools\clism"

echo.
echo Preparing user directories ...
if not exist "%USERPROFILE%\Tools\" (
    mkdir "%USERPROFILE%\Tools"
    if errorlevel 1 (
        echo MANUAL: Create "%USERPROFILE%\Tools".
        set "NEEDS_MANUAL=1"
    )
)
if not exist "%USERPROFILE%\.dir_history" (
    type nul > "%USERPROFILE%\.dir_history"
    if errorlevel 1 (
        echo MANUAL: Create "%USERPROFILE%\.dir_history".
        set "NEEDS_MANUAL=1"
    )
)

echo.
echo Copying bin ...
xcopy /s /y "%SRC%\bin" "%USERPROFILE%\bin\"
if errorlevel 1 (
    echo MANUAL: Copy "%SRC%\bin" to "%USERPROFILE%\bin".
    set "NEEDS_MANUAL=1"
)

echo.
echo Copying Google Japanese IME key bindings ...
mkdir "%USERPROFILE%\.config\googleime" 2>nul
copy /y "%SRC%\googleime\keybind.txt" "%USERPROFILE%\.config\googleime\keybind.txt"
if errorlevel 1 (
    echo MANUAL: Copy "%SRC%\googleime\keybind.txt" to "%USERPROFILE%\.config\googleime\keybind.txt".
    set "NEEDS_MANUAL=1"
)

echo.
echo Installing Keyhac 2 ...
if exist "%KEYHAC_DIR%\Keyhac.exe" (
    echo   SKIP: %KEYHAC_DIR%\Keyhac.exe already exists
    goto :keyhac_existing
)
set "KEYHAC_URL="
for /f "delims=" %%u in ('powershell -NoProfile -Command "(Invoke-RestMethod 'https://api.github.com/repos/crftwr/keyhac/releases/latest').assets | Where-Object { $_.name -match '^Keyhac-2\..+-win(-x64|64)\.zip$' } | Select-Object -First 1 -ExpandProperty browser_download_url"') do set "KEYHAC_URL=%%u"
if not defined KEYHAC_URL (
    echo   ERROR: Keyhac 2 Windows ZIP not found.
    set "NEEDS_MANUAL=1"
    goto :keyhac_done
)
echo   %KEYHAC_URL%
curl -fL "%KEYHAC_URL%" -o "%TEMP_DIR%\keyhac.zip"
if errorlevel 1 (
    echo   ERROR: Keyhac download failed.
    set "NEEDS_MANUAL=1"
    goto :keyhac_done
)
tar xvf "%TEMP_DIR%\keyhac.zip" -C "%TEMP_DIR%"
if errorlevel 1 (
    echo   ERROR: Keyhac extraction failed. ZIP: "%TEMP_DIR%\keyhac.zip"
    set "NEEDS_MANUAL=1"
    goto :keyhac_done
)
if not exist "%TEMP_DIR%\Keyhac\Keyhac.exe" (
    echo   ERROR: Keyhac.exe not found in ZIP: "%TEMP_DIR%\keyhac.zip".
    set "NEEDS_MANUAL=1"
    goto :keyhac_done
)
copy /y "%SRC%\keyhac\config.py" "%TEMP_DIR%\Keyhac\config.py" >nul
if errorlevel 1 (
    echo   ERROR: Could not bundle config.py with Keyhac.
    echo   Source: "%SRC%\keyhac\config.py"
    echo   Working folder: "%TEMP_DIR%\Keyhac"
    set "NEEDS_MANUAL=1"
    goto :keyhac_done
)
if exist "%KEYHAC_DIR%\" (
    echo MANUAL: "%KEYHAC_DIR%" is incomplete. Copy files from "%TEMP_DIR%\Keyhac" into it.
    echo         ZIP: "%TEMP_DIR%\keyhac.zip"
    set "NEEDS_MANUAL=1"
    goto :keyhac_done
)
move "%TEMP_DIR%\Keyhac" "%KEYHAC_DIR%"
if not exist "%KEYHAC_DIR%\Keyhac.exe" (
    if exist "%TEMP_DIR%\Keyhac\Keyhac.exe" (
        echo MANUAL: Move "%TEMP_DIR%\Keyhac" to "%KEYHAC_DIR%". config.py is included.
    ) else (
        echo MANUAL: Extract "%TEMP_DIR%\keyhac.zip", add "%SRC%\keyhac\config.py" to the Keyhac folder, then move it to "%KEYHAC_DIR%".
    )
    echo         ZIP: "%TEMP_DIR%\keyhac.zip"
    set "NEEDS_MANUAL=1"
)

:keyhac_done
goto :clism

:keyhac_existing
echo.
echo Updating existing Keyhac config ...
copy /y "%SRC%\keyhac\config.py" "%KEYHAC_DIR%\config.py"
if errorlevel 1 (
    echo MANUAL: Copy "%SRC%\keyhac\config.py" to "%KEYHAC_DIR%\config.py".
    set "NEEDS_MANUAL=1"
)

:clism
echo.
echo Installing CLISM excellent ...
if exist "%CLISM_DIR%\CLISM64.EXE" (
    echo   SKIP: %CLISM_DIR%\CLISM64.EXE already exists
    goto :clism_ready
)
set "CLISM_URL="
for /f "delims=" %%u in ('powershell -NoProfile -Command "$page=(Invoke-WebRequest -UseBasicParsing 'https://toroidj.github.io/slwin4.html').Content; [regex]::Match($page, 'https://toroidj.github.io/win/clisme[0-9]+\.zip').Value"') do set "CLISM_URL=%%u"
if not defined CLISM_URL (
    echo   ERROR: CLISM excellent download link not found.
    set "NEEDS_MANUAL=1"
    goto :clism_ready
)
echo   %CLISM_URL%
curl -fL "%CLISM_URL%" -o "%TEMP_DIR%\clism.zip"
if errorlevel 1 (
    echo   ERROR: CLISM download failed.
    set "NEEDS_MANUAL=1"
    goto :clism_ready
)
mkdir "%TEMP_DIR%\clism"
if errorlevel 1 (
    echo   ERROR: Could not create "%TEMP_DIR%\clism".
    echo         ZIP: "%TEMP_DIR%\clism.zip"
    set "NEEDS_MANUAL=1"
    goto :clism_ready
)
tar xvf "%TEMP_DIR%\clism.zip" -C "%TEMP_DIR%\clism"
if errorlevel 1 (
    echo   ERROR: CLISM extraction failed. ZIP: "%TEMP_DIR%\clism.zip"
    set "NEEDS_MANUAL=1"
    goto :clism_ready
)
if not exist "%TEMP_DIR%\clism\CLISM64.EXE" (
    echo   ERROR: CLISM64.EXE not found in ZIP: "%TEMP_DIR%\clism.zip".
    set "NEEDS_MANUAL=1"
    goto :clism_ready
)
if not exist "%TEMP_DIR%\clism\CLISM64.DLL" (
    echo   ERROR: CLISM64.DLL not found in ZIP: "%TEMP_DIR%\clism.zip".
    set "NEEDS_MANUAL=1"
    goto :clism_ready
)
if exist "%CLISM_DIR%\" (
    echo MANUAL: "%CLISM_DIR%" is incomplete. Copy files from "%TEMP_DIR%\clism" into it.
    echo         ZIP: "%TEMP_DIR%\clism.zip"
    set "NEEDS_MANUAL=1"
    goto :clism_ready
)
move "%TEMP_DIR%\clism" "%CLISM_DIR%"
if not exist "%CLISM_DIR%\CLISM64.EXE" (
    if exist "%TEMP_DIR%\clism\CLISM64.EXE" (
        echo MANUAL: Move "%TEMP_DIR%\clism" to "%CLISM_DIR%".
    ) else (
        echo MANUAL: Extract "%TEMP_DIR%\clism.zip" and copy its files to "%CLISM_DIR%".
    )
    echo         ZIP: "%TEMP_DIR%\clism.zip"
    set "NEEDS_MANUAL=1"
)

:clism_ready
echo.
echo Copying install scripts ...
mkdir "%USERPROFILE%\exe" 2>nul
xcopy /s /y "%SRC%\exe\install" "%USERPROFILE%\exe\install\"
if errorlevel 1 (
    echo MANUAL: Copy "%SRC%\exe\install" to "%USERPROFILE%\exe\install".
    set "NEEDS_MANUAL=1"
)

echo.
echo Running install_exefiles.bat ...
call "%SRC%\exe\install\install_exefiles.bat"
if errorlevel 1 set "NEEDS_MANUAL=1"

echo.
echo Running update_nvim.bat ...
call "%SRC%\exe\install\update_nvim.bat"
if errorlevel 1 set "NEEDS_MANUAL=1"

echo.
echo Running install_plemoljp_nf.bat ...
call "%SRC%\exe\install\install_plemoljp_nf.bat"
if errorlevel 1 set "NEEDS_MANUAL=1"

echo.
echo Running create_startup.bat ...
call "%SRC%\exe\install\create_startup.bat"
if errorlevel 1 set "NEEDS_MANUAL=1"

echo.
if "%NEEDS_MANUAL%"=="1" (
    echo Setup continued, but manual steps remain. Files and ZIPs: "%TEMP_DIR%"
    echo Keep this directory until all MANUAL steps above are complete.
    exit /b 1
)
rd /s /q "%TEMP_DIR%"
echo All done!
exit /b 0

:fail
echo.
echo Installation failed. Files and ZIPs remain in "%TEMP_DIR%".
exit /b 1
