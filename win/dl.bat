@echo off
setlocal

set TEMP_DIR=%TEMP%\dotfiles_%RANDOM%
set ZIP_URL=https://github.com/t-akira012/dotfiles/archive/refs/heads/main.zip

echo Downloading dotfiles ...
mkdir "%TEMP_DIR%" 2>nul
curl -fL "%ZIP_URL%" -o "%TEMP_DIR%\dotfiles.zip"
if errorlevel 1 goto :fail
tar xvf "%TEMP_DIR%\dotfiles.zip" -C "%TEMP_DIR%"
if errorlevel 1 goto :fail

set SRC=%TEMP_DIR%\dotfiles-main\win
set KEYHAC_DIR=%USERPROFILE%\Tools\keyhac
set CLISM_DIR=%USERPROFILE%\Tools\clism

echo.
echo Preparing user directories ...
if not exist "%USERPROFILE%\Tools\" (
    mkdir "%USERPROFILE%\Tools"
    if errorlevel 1 goto :fail
)
if not exist "%USERPROFILE%\.dir_history" (
    type nul > "%USERPROFILE%\.dir_history"
    if errorlevel 1 goto :fail
)

echo.
echo Copying bin ...
xcopy /s /y "%SRC%\bin" "%USERPROFILE%\bin\"
if errorlevel 1 goto :fail

echo.
echo Copying googleime\keybind.txt ...
mkdir "%USERPROFILE%\.config\googleime" 2>nul
copy /y "%SRC%\googleime\keybind.txt" "%USERPROFILE%\.config\googleime\keybind.txt"
if errorlevel 1 goto :fail

echo.
echo Installing Keyhac 2 ...
set "KEYHAC_URL="
for /f "delims=" %%u in ('powershell -NoProfile -Command "(Invoke-RestMethod 'https://api.github.com/repos/crftwr/keyhac/releases/latest').assets | Where-Object { $_.name -like 'Keyhac-2.*-win64.zip' } | Select-Object -First 1 -ExpandProperty browser_download_url"') do set "KEYHAC_URL=%%u"
if not defined KEYHAC_URL (
    echo   ERROR: Keyhac 2 Windows asset not found
    goto :fail
)
echo   %KEYHAC_URL%
curl -fL "%KEYHAC_URL%" -o "%TEMP_DIR%\keyhac.zip"
if errorlevel 1 goto :fail
tar xvf "%TEMP_DIR%\keyhac.zip" -C "%TEMP_DIR%"
if errorlevel 1 goto :fail
if not exist "%TEMP_DIR%\Keyhac\Keyhac.exe" goto :fail
if exist "%KEYHAC_DIR%\" (
    echo Stopping Keyhac from %KEYHAC_DIR% ...
    powershell -NoProfile -Command "$ErrorActionPreference='Stop'; $target=Join-Path $env:USERPROFILE 'Tools\keyhac\Keyhac.exe'; Get-CimInstance Win32_Process -Filter 'Name=''Keyhac.exe''' | Where-Object { $_.ExecutablePath -eq $target } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction Stop }"
    if errorlevel 1 goto :fail
    echo Removing previous Keyhac ...
    rd /s /q "%KEYHAC_DIR%"
    if errorlevel 1 goto :fail
)
move "%TEMP_DIR%\Keyhac" "%KEYHAC_DIR%"
if errorlevel 1 goto :fail

echo.
echo Copying keyhac\config.py ...
if not exist "%KEYHAC_DIR%\Keyhac.exe" (
    echo   ERROR: Keyhac.exe not found; config.py was not copied
    goto :fail
)
copy /y "%SRC%\keyhac\config.py" "%KEYHAC_DIR%\config.py"
if errorlevel 1 goto :fail

echo.
echo Installing CLISM excellent ...
set "CLISM_URL="
for /f "delims=" %%u in ('powershell -NoProfile -Command "$page=(Invoke-WebRequest -UseBasicParsing 'https://toroidj.github.io/slwin4.html').Content; [regex]::Match($page, 'https://toroidj.github.io/win/clisme[0-9]+\.zip').Value"') do set "CLISM_URL=%%u"
if not defined CLISM_URL (
    echo   ERROR: CLISM excellent download link not found
    goto :fail
)
echo   %CLISM_URL%
curl -fL "%CLISM_URL%" -o "%TEMP_DIR%\clism.zip"
if errorlevel 1 goto :fail
mkdir "%TEMP_DIR%\clism"
if errorlevel 1 goto :fail
tar xvf "%TEMP_DIR%\clism.zip" -C "%TEMP_DIR%\clism"
if errorlevel 1 goto :fail
if not exist "%TEMP_DIR%\clism\CLISM64.EXE" goto :fail
if not exist "%TEMP_DIR%\clism\CLISM64.DLL" goto :fail
if exist "%CLISM_DIR%\" (
    echo Stopping CLISM excellent from %CLISM_DIR% ...
    powershell -NoProfile -Command "$ErrorActionPreference='Stop'; $root=Join-Path $env:USERPROFILE 'Tools\clism\'; Get-CimInstance Win32_Process | Where-Object { $_.ExecutablePath -and $_.ExecutablePath.StartsWith($root,[StringComparison]::OrdinalIgnoreCase) } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction Stop }"
    if errorlevel 1 goto :fail
    echo Removing previous CLISM excellent ...
    rd /s /q "%CLISM_DIR%"
    if errorlevel 1 goto :fail
)
move "%TEMP_DIR%\clism" "%CLISM_DIR%"
if errorlevel 1 goto :fail

echo.
echo Copying install_exefiles.bat ...
mkdir "%USERPROFILE%\exe" 2>nul
copy /y "%SRC%\exe\install_exefiles.bat" "%USERPROFILE%\exe\install_exefiles.bat"
if errorlevel 1 goto :fail

echo.
echo Copying update_nvim.bat ...
copy /y "%SRC%\exe\update_nvim.bat" "%USERPROFILE%\exe\update_nvim.bat"
if errorlevel 1 goto :fail

echo.
echo Copying create_startup.bat ...
copy /y "%SRC%\exe\create_startup.bat" "%USERPROFILE%\exe\create_startup.bat"
if errorlevel 1 goto :fail

echo.
echo Copying winget\install_apps.bat ...
mkdir "%USERPROFILE%\exe\winget" 2>nul
copy /y "%SRC%\exe\winget\install_apps.bat" "%USERPROFILE%\exe\winget\install_apps.bat"
if errorlevel 1 goto :fail

echo.
echo Running install_exefiles.bat ...
call "%USERPROFILE%\exe\install_exefiles.bat"

echo.
echo Running update_nvim.bat ...
call "%USERPROFILE%\exe\update_nvim.bat"
if errorlevel 1 goto :fail

echo.
echo Running create_startup.bat ...
call "%USERPROFILE%\exe\create_startup.bat"
if errorlevel 1 goto :fail

rd /s /q "%TEMP_DIR%"
echo.
echo All done!
exit /b 0

:fail
rd /s /q "%TEMP_DIR%"
echo.
echo Installation failed.
exit /b 1
