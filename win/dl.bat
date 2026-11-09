@echo off
setlocal
chcp 65001 >nul

set "TEMP_DIR=%USERPROFILE%\Downloads\tmp\dotfiles_%RANDOM%"
set "ZIP_URL=https://github.com/t-akira012/dotfiles/archive/refs/heads/main.zip"
set "NEEDS_MANUAL=0"

echo dotfiles をダウンロードしています...
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
echo ユーザーディレクトリを準備しています...
if not exist "%USERPROFILE%\Tools\" (
    mkdir "%USERPROFILE%\Tools"
    if errorlevel 1 (
        echo 手動: 作成してください: "%USERPROFILE%\Tools".
        set "NEEDS_MANUAL=1"
    )
)
if not exist "%USERPROFILE%\.dir_history" (
    type nul > "%USERPROFILE%\.dir_history"
    if errorlevel 1 (
        echo 手動: 作成してください: "%USERPROFILE%\.dir_history".
        set "NEEDS_MANUAL=1"
    )
)

echo.
echo bin をコピーしています...
xcopy /s /y "%SRC%\bin" "%USERPROFILE%\bin\"
if errorlevel 1 (
    echo 手動: コピーしてください: "%SRC%\bin" → "%USERPROFILE%\bin".
    set "NEEDS_MANUAL=1"
)

echo.
echo Google 日本語入力のキー設定をコピーしています...
mkdir "%USERPROFILE%\.config\googleime" 2>nul
copy /y "%SRC%\googleime\keybind.txt" "%USERPROFILE%\.config\googleime\keybind.txt"
if errorlevel 1 (
    echo 手動: コピーしてください: "%SRC%\googleime\keybind.txt" → "%USERPROFILE%\.config\googleime\keybind.txt".
    set "NEEDS_MANUAL=1"
)

echo.
echo Keyhac 2 を導入しています...
if exist "%KEYHAC_DIR%\Keyhac.exe" (
    echo   スキップ: %KEYHAC_DIR%\Keyhac.exe は配置済みです
    goto :keyhac_existing
)
set "KEYHAC_URL="
for /f "delims=" %%u in ('powershell -NoProfile -Command "(Invoke-RestMethod 'https://api.github.com/repos/crftwr/keyhac/releases/latest').assets | Where-Object { $_.name -match '^Keyhac-2\..+-win(-x64|64)\.zip$' } | Select-Object -First 1 -ExpandProperty browser_download_url"') do set "KEYHAC_URL=%%u"
if not defined KEYHAC_URL (
    echo   エラー: Keyhac 2 の Windows 版 ZIP が見つかりません。
    set "NEEDS_MANUAL=1"
    goto :keyhac_done
)
echo   %KEYHAC_URL%
curl -fL "%KEYHAC_URL%" -o "%TEMP_DIR%\keyhac.zip"
if errorlevel 1 (
    echo   エラー: Keyhac のダウンロードに失敗しました。
    set "NEEDS_MANUAL=1"
    goto :keyhac_done
)
tar xvf "%TEMP_DIR%\keyhac.zip" -C "%TEMP_DIR%"
if errorlevel 1 (
    echo   エラー: Keyhac の展開に失敗しました。ZIP: "%TEMP_DIR%\keyhac.zip"
    set "NEEDS_MANUAL=1"
    goto :keyhac_done
)
if not exist "%TEMP_DIR%\Keyhac\Keyhac.exe" (
    echo   エラー: Keyhac.exe が ZIP 内に見つかりません: "%TEMP_DIR%\keyhac.zip".
    set "NEEDS_MANUAL=1"
    goto :keyhac_done
)
copy /y "%SRC%\keyhac\config.py" "%TEMP_DIR%\Keyhac\config.py" >nul
if errorlevel 1 (
    echo   エラー: Keyhac フォルダに config.py を組み込めませんでした。
    echo   元ファイル: "%SRC%\keyhac\config.py"
    echo   作業フォルダ: "%TEMP_DIR%\Keyhac"
    set "NEEDS_MANUAL=1"
    goto :keyhac_done
)
if exist "%KEYHAC_DIR%\" (
    echo 手動: "%KEYHAC_DIR%" に Keyhac.exe がありません。"%TEMP_DIR%\Keyhac" からコピーしてください。
    echo         ZIP: "%TEMP_DIR%\keyhac.zip"
    set "NEEDS_MANUAL=1"
    goto :keyhac_done
)
move "%TEMP_DIR%\Keyhac" "%KEYHAC_DIR%"
if not exist "%KEYHAC_DIR%\Keyhac.exe" (
    if exist "%TEMP_DIR%\Keyhac\Keyhac.exe" (
        echo 手動: "%TEMP_DIR%\Keyhac" を "%KEYHAC_DIR%" に移動してください。config.py は組み込み済みです。
    ) else (
        echo 手動: "%TEMP_DIR%\keyhac.zip" を展開し、Keyhac フォルダに "%SRC%\keyhac\config.py" を入れてから "%KEYHAC_DIR%" に移動してください。
    )
    echo         ZIP: "%TEMP_DIR%\keyhac.zip"
    set "NEEDS_MANUAL=1"
)

:keyhac_done
goto :clism

:keyhac_existing
echo.
echo 既存の Keyhac の設定を更新しています...
copy /y "%SRC%\keyhac\config.py" "%KEYHAC_DIR%\config.py"
if errorlevel 1 (
    echo 手動: コピーしてください: "%SRC%\keyhac\config.py" → "%KEYHAC_DIR%\config.py".
    set "NEEDS_MANUAL=1"
)

:clism
echo.
echo CLISM excellent を導入しています...
if exist "%CLISM_DIR%\CLISM64.EXE" (
    echo   スキップ: %CLISM_DIR%\CLISM64.EXE は配置済みです
    goto :clism_ready
)
set "CLISM_URL="
for /f "delims=" %%u in ('powershell -NoProfile -Command "$page=(Invoke-WebRequest -UseBasicParsing 'https://toroidj.github.io/slwin4.html').Content; [regex]::Match($page, 'https://toroidj.github.io/win/clisme[0-9]+\.zip').Value"') do set "CLISM_URL=%%u"
if not defined CLISM_URL (
    echo   エラー: CLISM excellent のダウンロード先が見つかりません。
    set "NEEDS_MANUAL=1"
    goto :clism_ready
)
echo   %CLISM_URL%
curl -fL "%CLISM_URL%" -o "%TEMP_DIR%\clism.zip"
if errorlevel 1 (
    echo   エラー: CLISM のダウンロードに失敗しました。
    set "NEEDS_MANUAL=1"
    goto :clism_ready
)
mkdir "%TEMP_DIR%\clism"
if errorlevel 1 (
    echo   エラー: ディレクトリを作成できません: "%TEMP_DIR%\clism".
    echo         ZIP: "%TEMP_DIR%\clism.zip"
    set "NEEDS_MANUAL=1"
    goto :clism_ready
)
tar xvf "%TEMP_DIR%\clism.zip" -C "%TEMP_DIR%\clism"
if errorlevel 1 (
    echo   エラー: CLISM の展開に失敗しました。ZIP: "%TEMP_DIR%\clism.zip"
    set "NEEDS_MANUAL=1"
    goto :clism_ready
)
if not exist "%TEMP_DIR%\clism\CLISM64.EXE" (
    echo   エラー: CLISM64.EXE が ZIP 内に見つかりません: "%TEMP_DIR%\clism.zip".
    set "NEEDS_MANUAL=1"
    goto :clism_ready
)
if not exist "%TEMP_DIR%\clism\CLISM64.DLL" (
    echo   エラー: CLISM64.DLL が ZIP 内に見つかりません: "%TEMP_DIR%\clism.zip".
    set "NEEDS_MANUAL=1"
    goto :clism_ready
)
if exist "%CLISM_DIR%\" (
    echo 手動: "%CLISM_DIR%" に CLISM64.EXE がありません。"%TEMP_DIR%\clism" からコピーしてください。
    echo         ZIP: "%TEMP_DIR%\clism.zip"
    set "NEEDS_MANUAL=1"
    goto :clism_ready
)
move "%TEMP_DIR%\clism" "%CLISM_DIR%"
if not exist "%CLISM_DIR%\CLISM64.EXE" (
    if exist "%TEMP_DIR%\clism\CLISM64.EXE" (
        echo 手動: "%TEMP_DIR%\clism" を "%CLISM_DIR%" に移動してください。
    ) else (
        echo 手動: "%TEMP_DIR%\clism.zip" を展開し、中のファイルを "%CLISM_DIR%" にコピーしてください。
    )
    echo         ZIP: "%TEMP_DIR%\clism.zip"
    set "NEEDS_MANUAL=1"
)

:clism_ready
echo.
echo 導入スクリプトをコピーしています...
mkdir "%USERPROFILE%\exe" 2>nul
xcopy /s /y "%SRC%\exe\install" "%USERPROFILE%\exe\install\"
if errorlevel 1 (
    echo 手動: コピーしてください: "%SRC%\exe\install" → "%USERPROFILE%\exe\install".
    set "NEEDS_MANUAL=1"
)

echo.
echo install_exefiles.bat を実行しています...
call "%SRC%\exe\install\install_exefiles.bat"
if errorlevel 1 set "NEEDS_MANUAL=1"

echo.
echo update_nvim.bat を実行しています...
call "%SRC%\exe\install\update_nvim.bat"
if errorlevel 1 set "NEEDS_MANUAL=1"

echo.
echo install_plemoljp_nf.bat を実行しています...
call "%SRC%\exe\install\install_plemoljp_nf.bat"
if errorlevel 1 set "NEEDS_MANUAL=1"

echo.
echo create_startup.bat を実行しています...
call "%SRC%\exe\install\create_startup.bat"
if errorlevel 1 set "NEEDS_MANUAL=1"

echo.
if "%NEEDS_MANUAL%"=="1" (
    echo セットアップは継続しましたが、手動作業が残っています。ファイルと ZIP: "%TEMP_DIR%"
    echo 上記の手動作業が終わるまで、このディレクトリを削除しないでください。
    exit /b 1
)
rd /s /q "%TEMP_DIR%"
echo セットアップが完了しました。
exit /b 0

:fail
echo.
echo セットアップに失敗しました。ファイルと ZIP は次に残しています: "%TEMP_DIR%".
exit /b 1
