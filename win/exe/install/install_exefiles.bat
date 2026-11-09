@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

set "EXE_DIR=%USERPROFILE%\exe"
set "TEMP_DIR=%USERPROFILE%\Downloads\tmp\gh_install_%RANDOM%"
set "FAILED=0"
if not exist "%EXE_DIR%\" (
    mkdir "%EXE_DIR%"
    if errorlevel 1 echo 手動: "%EXE_DIR%" を作成してください。
)
if not exist "%TEMP_DIR%\" (
    mkdir "%TEMP_DIR%"
    if errorlevel 1 goto :fail
)

echo CLI ツールを %EXE_DIR% に導入しています...

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
echo CLI ツールの導入が完了しました。
exit /b 0

:fail
echo.
echo 一部の CLI ツールは手動配置が必要です。ファイルと ZIP: "%TEMP_DIR%"
exit /b 1

:dl_exe
set "REPO=%~1"
set "PATTERN=%~2"
set "EXE=%~3"

if exist "%EXE_DIR%\%EXE%" (
    echo.
    echo [%REPO%] スキップ: %EXE% は配置済みです。
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
    echo   エラー: %REPO% の配布ファイルが見つかりません。
    exit /b 1
)

echo   %URL%
curl -fL "%URL%" -o "%WORK%\archive.zip"
if errorlevel 1 (
    echo   エラー: %REPO% のダウンロードに失敗しました。
    exit /b 1
)
if not exist "%WORK%\archive.zip" (
    echo   エラー: %REPO% の ZIP が作成されませんでした。
    exit /b 1
)
tar xvf "%WORK%\archive.zip" -C "%WORK%"
if errorlevel 1 (
    echo   エラー: %REPO% の展開に失敗しました。
    exit /b 1
)

set "FOUND=0"
for /r "%WORK%" %%f in (%EXE%) do (
    if exist "%%f" (
        copy /y "%%f" "%EXE_DIR%\%EXE%" >nul
        if errorlevel 1 (
            echo   手動: "%%f" を "%EXE_DIR%\%EXE%" にコピーしてください。
            echo           ZIP: "%WORK%\archive.zip"
            exit /b 1
        )
        set "FOUND=1"
    )
)
if "!FOUND!"=="0" (
    echo   エラー: ZIP 内に %EXE% が見つかりません。
    exit /b 1
)
if not exist "%EXE_DIR%\%EXE%" (
    echo   エラー: %EXE% が配置されていません。
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
    echo [%REPO%] スキップ: %DIR_NAME% は配置済みです。
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
    echo   エラー: %REPO% の配布ファイルが見つかりません。
    exit /b 1
)

echo   %URL%
curl -fL "%URL%" -o "%WORK%\archive.zip"
if errorlevel 1 (
    echo   エラー: %REPO% のダウンロードに失敗しました。
    exit /b 1
)
if not exist "%WORK%\archive.zip" (
    echo   エラー: %REPO% の ZIP が作成されませんでした。
    exit /b 1
)
tar xvf "%WORK%\archive.zip" -C "%WORK%"
if errorlevel 1 (
    echo   エラー: %REPO% の展開に失敗しました。
    exit /b 1
)
if not exist "%WORK%\%DIR_NAME%\%REQUIRED_FILE%" (
    echo   エラー: %DIR_NAME% 内に %REQUIRED_FILE% が見つかりません。
    exit /b 1
)
if exist "%EXE_DIR%\%DIR_NAME%\" (
    echo   手動: "%WORK%\%DIR_NAME%" の中身を "%EXE_DIR%\%DIR_NAME%" にコピーしてください。
    echo           ZIP: "%WORK%\archive.zip"
    exit /b 1
)
move "%WORK%\%DIR_NAME%" "%EXE_DIR%\%DIR_NAME%" >nul
if errorlevel 1 (
    echo   手動: "%WORK%\%DIR_NAME%" を "%EXE_DIR%\%DIR_NAME%" に移動してください。
    echo           ZIP: "%WORK%\archive.zip"
    exit /b 1
)
if not exist "%EXE_DIR%\%DIR_NAME%\%REQUIRED_FILE%" (
    echo   エラー: %DIR_NAME% が配置されていません。
    exit /b 1
)
echo   -^> %EXE_DIR%\%DIR_NAME%
exit /b 0

:dl_git
if exist "%EXE_DIR%\git-bash\cmd\git.exe" (
    echo.
    echo [git-for-windows/git] スキップ: git-bash は配置済みです。
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
    echo   エラー: PortableGit の配布ファイルが見つかりません。
    exit /b 1
)

echo   %URL%
curl -fL "%URL%" -o "%WORK%\PortableGit.exe"
if errorlevel 1 (
    echo   エラー: PortableGit のダウンロードに失敗しました。
    exit /b 1
)
if not exist "%WORK%\PortableGit.exe" (
    echo   エラー: PortableGit の実行ファイルが作成されませんでした。
    exit /b 1
)
"%WORK%\PortableGit.exe" -o"%WORK%\git-bash" -y
if errorlevel 1 (
    echo   エラー: PortableGit の展開に失敗しました。
    exit /b 1
)
if not exist "%WORK%\git-bash\cmd\git.exe" (
    echo   エラー: PortableGit 内に git.exe が見つかりません。
    exit /b 1
)
if exist "%EXE_DIR%\git-bash\" (
    echo   手動: "%WORK%\git-bash" の中身を "%EXE_DIR%\git-bash" にコピーしてください。
    echo           配布ファイル: "%WORK%\PortableGit.exe"
    exit /b 1
)
move "%WORK%\git-bash" "%EXE_DIR%\git-bash" >nul
if errorlevel 1 (
    echo   手動: "%WORK%\git-bash" を "%EXE_DIR%\git-bash" に移動してください。
    echo           配布ファイル: "%WORK%\PortableGit.exe"
    exit /b 1
)
if not exist "%EXE_DIR%\git-bash\cmd\git.exe" (
    echo   エラー: PortableGit が配置されていません。
    exit /b 1
)
echo   -^> %EXE_DIR%\git-bash
exit /b 0
