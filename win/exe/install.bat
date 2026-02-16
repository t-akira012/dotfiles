@echo off
setlocal enabledelayedexpansion

set EXE_DIR=%USERPROFILE%\exe
set TEMP_DIR=%TEMP%\gh_install_%RANDOM%
mkdir "%EXE_DIR%" 2>nul

echo Installing CLI tools to %EXE_DIR% ...

call :install "junegunn/fzf"       "windows_amd64.zip"          "fzf.exe"
call :install "x-motemen/ghq"      "windows_amd64.zip"          "ghq.exe"
call :install "sharkdp/fd"         "x86_64-pc-windows-msvc.zip" "fd.exe"
call :install "eza-community/eza"  "x86_64-pc-windows-gnu.zip"  "eza.exe"
call :install "sharkdp/bat"        "x86_64-pc-windows-msvc.zip" "bat.exe"
call :install "BurntSushi/ripgrep" "x86_64-pc-windows-msvc.zip" "rg.exe"

echo.
echo Done! Make sure %%USERPROFILE%%\exe is in your PATH.
goto :eof

:install
set "REPO=%~1"
set "PATTERN=%~2"
set "EXE=%~3"
set "WORK=%TEMP_DIR%\%EXE%"
mkdir "%WORK%" 2>nul

echo.
echo [%REPO%]

set "URL="
for /f "delims=" %%u in ('powershell -NoProfile -Command "(Invoke-RestMethod 'https://api.github.com/repos/%REPO%/releases/latest').assets | Where-Object { $_.name -like '*%PATTERN%' } | Select-Object -First 1 -ExpandProperty browser_download_url"') do set "URL=%%u"

if not defined URL (
    echo   ERROR: asset not found
    goto :eof
)

echo   %URL%
curl -sL "%URL%" -o "%WORK%\archive.zip"
tar xvf "%WORK%\archive.zip" -C "%WORK%"

for /r "%WORK%" %%f in (%EXE%) do (
    copy /y "%%f" "%EXE_DIR%\%EXE%" >nul
    echo   -^> %EXE_DIR%\%EXE%
)

rd /s /q "%WORK%"
goto :eof
