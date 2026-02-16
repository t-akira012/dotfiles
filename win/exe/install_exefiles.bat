@echo off
setlocal enabledelayedexpansion

set EXE_DIR=%USERPROFILE%\exe
set TEMP_DIR=%TEMP%\gh_install_%RANDOM%
mkdir "%EXE_DIR%" 2>nul

echo Installing CLI tools to %EXE_DIR% ...

:: Single exe tools
call :dl_exe "junegunn/fzf"       "windows_amd64.zip"          "fzf.exe"
call :dl_exe "x-motemen/ghq"      "windows_amd64.zip"          "ghq.exe"
call :dl_exe "sharkdp/fd"         "x86_64-pc-windows-msvc.zip" "fd.exe"
call :dl_exe "eza-community/eza"  "x86_64-pc-windows-gnu.zip"  "eza.exe"
call :dl_exe "sharkdp/bat"        "x86_64-pc-windows-msvc.zip" "bat.exe"
call :dl_exe "BurntSushi/ripgrep" "x86_64-pc-windows-msvc.zip" "rg.exe"

:: Directory-based tools
call :dl_dir "neovim/neovim" "nvim-win64.zip" "nvim-win64"
call :dl_git

echo.
echo Done!
goto :eof

:dl_exe
set "REPO=%~1"
set "PATTERN=%~2"
set "EXE=%~3"

if exist "%EXE_DIR%\%EXE%" (
    echo.
    echo [%REPO%] SKIP: %EXE% already exists
    goto :eof
)

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

:dl_dir
set "REPO=%~1"
set "PATTERN=%~2"
set "DIR_NAME=%~3"

if exist "%EXE_DIR%\%DIR_NAME%" (
    echo.
    echo [%REPO%] SKIP: %DIR_NAME% already exists
    goto :eof
)

set "WORK=%TEMP_DIR%\dir_%RANDOM%"
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
tar xvf "%WORK%\archive.zip" -C "%EXE_DIR%"
echo   -^> %EXE_DIR%\%DIR_NAME%

rd /s /q "%WORK%"
goto :eof

:dl_git
if exist "%EXE_DIR%\git-bash" (
    echo.
    echo [git-for-windows/git] SKIP: git-bash already exists
    goto :eof
)

echo.
echo [git-for-windows/git]

set "WORK=%TEMP_DIR%\git"
mkdir "%WORK%" 2>nul

set "URL="
for /f "delims=" %%u in ('powershell -NoProfile -Command "(Invoke-RestMethod 'https://api.github.com/repos/git-for-windows/git/releases/latest').assets | Where-Object { $_.name -like 'PortableGit-*-64-bit.7z.exe' } | Select-Object -First 1 -ExpandProperty browser_download_url"') do set "URL=%%u"

if not defined URL (
    echo   ERROR: asset not found
    goto :eof
)

echo   %URL%
curl -sL "%URL%" -o "%WORK%\PortableGit.exe"
"%WORK%\PortableGit.exe" -o"%EXE_DIR%\git-bash" -y
echo   -^> %EXE_DIR%\git-bash

rd /s /q "%WORK%"
goto :eof
