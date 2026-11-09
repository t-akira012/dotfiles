@echo off
setlocal enabledelayedexpansion

set "EXE_DIR=%USERPROFILE%\exe"
set "TEMP_DIR=%USERPROFILE%\Downloads\tmp\gh_install_%RANDOM%"
set "FAILED=0"
if not exist "%EXE_DIR%\" (
    mkdir "%EXE_DIR%"
    if errorlevel 1 echo MANUAL: Create "%EXE_DIR%".
)
if not exist "%TEMP_DIR%\" (
    mkdir "%TEMP_DIR%"
    if errorlevel 1 goto :fail
)

echo Installing CLI tools to %EXE_DIR% ...

:: Single exe tools
call :dl_exe "junegunn/fzf"       "windows_amd64.zip"          "fzf.exe"
if errorlevel 1 set "FAILED=1"
call :dl_exe "x-motemen/ghq"      "windows_amd64.zip"          "ghq.exe"
if errorlevel 1 set "FAILED=1"
call :dl_exe "sharkdp/fd"         "x86_64-pc-windows-msvc.zip" "fd.exe"
if errorlevel 1 set "FAILED=1"
call :dl_exe "eza-community/eza"  "x86_64-pc-windows-gnu.zip"  "eza.exe"
if errorlevel 1 set "FAILED=1"
call :dl_exe "sharkdp/bat"        "x86_64-pc-windows-msvc.zip" "bat.exe"
if errorlevel 1 set "FAILED=1"
call :dl_exe "BurntSushi/ripgrep" "x86_64-pc-windows-msvc.zip" "rg.exe"
if errorlevel 1 set "FAILED=1"

:: Directory-based tools
call :dl_dir "neovim/neovim" "nvim-win64.zip" "nvim-win64" "bin\nvim.exe"
if errorlevel 1 set "FAILED=1"
call :dl_git
if errorlevel 1 set "FAILED=1"

if "%FAILED%"=="1" goto :fail
rd /s /q "%TEMP_DIR%"
echo.
echo Done!
exit /b 0

:fail
echo.
echo Some CLI tools need manual installation. Files and archives: "%TEMP_DIR%"
exit /b 1

:dl_exe
set "REPO=%~1"
set "PATTERN=%~2"
set "EXE=%~3"

if exist "%EXE_DIR%\%EXE%" (
    echo.
    echo [%REPO%] SKIP: %EXE% already exists
    exit /b 0
)

set "WORK=%TEMP_DIR%\%EXE%"
mkdir "%WORK%"
if errorlevel 1 exit /b 1

echo.
echo [%REPO%]
set "URL="
for /f "delims=" %%u in ('powershell -NoProfile -Command "(Invoke-RestMethod 'https://api.github.com/repos/%REPO%/releases/latest').assets | Where-Object { $_.name -like '*%PATTERN%' } | Select-Object -First 1 -ExpandProperty browser_download_url"') do set "URL=%%u"
if not defined URL (
    echo   ERROR: asset not found for %REPO%
    exit /b 1
)

echo   %URL%
curl -fL "%URL%" -o "%WORK%\archive.zip"
if errorlevel 1 (
    echo   ERROR: download failed for %REPO%
    exit /b 1
)
if not exist "%WORK%\archive.zip" (
    echo   ERROR: download did not create an archive for %REPO%
    exit /b 1
)
tar xvf "%WORK%\archive.zip" -C "%WORK%"
if errorlevel 1 (
    echo   ERROR: extraction failed for %REPO%
    exit /b 1
)

set "FOUND=0"
for /r "%WORK%" %%f in (%EXE%) do (
    if exist "%%f" (
        copy /y "%%f" "%EXE_DIR%\%EXE%" >nul
        if errorlevel 1 (
            echo   MANUAL: Copy "%%f" to "%EXE_DIR%\%EXE%".
            echo           ZIP: "%WORK%\archive.zip"
            exit /b 1
        )
        set "FOUND=1"
    )
)
if "!FOUND!"=="0" (
    echo   ERROR: %EXE% not found in the archive
    exit /b 1
)
if not exist "%EXE_DIR%\%EXE%" (
    echo   ERROR: %EXE% was not installed
    exit /b 1
)
echo   -^> %EXE_DIR%\%EXE%
exit /b 0

:dl_dir
set "REPO=%~1"
set "PATTERN=%~2"
set "DIR_NAME=%~3"
set "REQUIRED_FILE=%~4"

if exist "%EXE_DIR%\%DIR_NAME%\%REQUIRED_FILE%" (
    echo.
    echo [%REPO%] SKIP: %DIR_NAME% already exists
    exit /b 0
)

set "WORK=%TEMP_DIR%\%DIR_NAME%"
mkdir "%WORK%"
if errorlevel 1 exit /b 1

echo.
echo [%REPO%]
set "URL="
for /f "delims=" %%u in ('powershell -NoProfile -Command "(Invoke-RestMethod 'https://api.github.com/repos/%REPO%/releases/latest').assets | Where-Object { $_.name -like '*%PATTERN%' } | Select-Object -First 1 -ExpandProperty browser_download_url"') do set "URL=%%u"
if not defined URL (
    echo   ERROR: asset not found for %REPO%
    exit /b 1
)

echo   %URL%
curl -fL "%URL%" -o "%WORK%\archive.zip"
if errorlevel 1 (
    echo   ERROR: download failed for %REPO%
    exit /b 1
)
if not exist "%WORK%\archive.zip" (
    echo   ERROR: download did not create an archive for %REPO%
    exit /b 1
)
tar xvf "%WORK%\archive.zip" -C "%WORK%"
if errorlevel 1 (
    echo   ERROR: extraction failed for %REPO%
    exit /b 1
)
if not exist "%WORK%\%DIR_NAME%\%REQUIRED_FILE%" (
    echo   ERROR: %REQUIRED_FILE% not found in %DIR_NAME%
    exit /b 1
)
if exist "%EXE_DIR%\%DIR_NAME%\" (
    echo   MANUAL: "%EXE_DIR%\%DIR_NAME%" is incomplete. Copy files from "%WORK%\%DIR_NAME%" into it.
    echo           ZIP: "%WORK%\archive.zip"
    exit /b 1
)
move "%WORK%\%DIR_NAME%" "%EXE_DIR%\%DIR_NAME%" >nul
if errorlevel 1 (
    echo   MANUAL: Move "%WORK%\%DIR_NAME%" to "%EXE_DIR%\%DIR_NAME%".
    echo           ZIP: "%WORK%\archive.zip"
    exit /b 1
)
if not exist "%EXE_DIR%\%DIR_NAME%\%REQUIRED_FILE%" (
    echo   ERROR: %DIR_NAME% was not installed
    exit /b 1
)
echo   -^> %EXE_DIR%\%DIR_NAME%
exit /b 0

:dl_git
if exist "%EXE_DIR%\git-bash\cmd\git.exe" (
    echo.
    echo [git-for-windows/git] SKIP: git-bash already exists
    exit /b 0
)

echo.
echo [git-for-windows/git]
set "WORK=%TEMP_DIR%\git"
mkdir "%WORK%"
if errorlevel 1 exit /b 1

set "URL="
for /f "delims=" %%u in ('powershell -NoProfile -Command "(Invoke-RestMethod 'https://api.github.com/repos/git-for-windows/git/releases/latest').assets | Where-Object { $_.name -like 'PortableGit-*-64-bit.7z.exe' } | Select-Object -First 1 -ExpandProperty browser_download_url"') do set "URL=%%u"
if not defined URL (
    echo   ERROR: PortableGit asset not found
    exit /b 1
)

echo   %URL%
curl -fL "%URL%" -o "%WORK%\PortableGit.exe"
if errorlevel 1 (
    echo   ERROR: PortableGit download failed
    exit /b 1
)
if not exist "%WORK%\PortableGit.exe" (
    echo   ERROR: PortableGit download did not create an executable
    exit /b 1
)
"%WORK%\PortableGit.exe" -o"%WORK%\git-bash" -y
if errorlevel 1 (
    echo   ERROR: PortableGit extraction failed
    exit /b 1
)
if not exist "%WORK%\git-bash\cmd\git.exe" (
    echo   ERROR: git.exe not found in PortableGit
    exit /b 1
)
if exist "%EXE_DIR%\git-bash\" (
    echo   MANUAL: "%EXE_DIR%\git-bash" is incomplete. Copy files from "%WORK%\git-bash" into it.
    echo           Archive: "%WORK%\PortableGit.exe"
    exit /b 1
)
move "%WORK%\git-bash" "%EXE_DIR%\git-bash" >nul
if errorlevel 1 (
    echo   MANUAL: Move "%WORK%\git-bash" to "%EXE_DIR%\git-bash".
    echo           Archive: "%WORK%\PortableGit.exe"
    exit /b 1
)
if not exist "%EXE_DIR%\git-bash\cmd\git.exe" (
    echo   ERROR: PortableGit was not installed
    exit /b 1
)
echo   -^> %EXE_DIR%\git-bash
exit /b 0
