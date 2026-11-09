@echo off
setlocal
chcp 65001 >nul

set "KEYHAC_EXE=%USERPROFILE%\Tools\keyhac\Keyhac.exe"
set "CLISM_EXE=%USERPROFILE%\Tools\clism\CLISM64.EXE"
set "FAILED=0"

if exist "%KEYHAC_EXE%" (
    echo Keyhac のスタートアップ登録をしています...
    powershell -NoProfile -Command "$ErrorActionPreference='Stop'; $shell=New-Object -ComObject WScript.Shell; $dir=[Environment]::GetFolderPath('Startup'); $link=$shell.CreateShortcut([IO.Path]::Combine($dir,'Keyhac.lnk')); $link.TargetPath=Join-Path $env:USERPROFILE 'Tools\keyhac\Keyhac.exe'; $link.WorkingDirectory=Join-Path $env:USERPROFILE 'Tools\keyhac'; $link.Save()"
    if errorlevel 1 (
        echo 手動: "%KEYHAC_EXE%" のショートカットをスタートアップに作成してください。
        set "FAILED=1"
    )
) else (
    echo スキップ: Keyhac.exe が見つかりません: "%KEYHAC_EXE%"
    echo 手動: Keyhac を配置した後、このスクリプトを再実行してください。
    set "FAILED=1"
)

if exist "%CLISM_EXE%" (
    echo CLISM excellent のスタートアップ登録をしています...
    powershell -NoProfile -Command "$ErrorActionPreference='Stop'; $shell=New-Object -ComObject WScript.Shell; $dir=[Environment]::GetFolderPath('Startup'); $link=$shell.CreateShortcut([IO.Path]::Combine($dir,'CLISM excellent.lnk')); $link.TargetPath=Join-Path $env:USERPROFILE 'Tools\clism\CLISM64.EXE'; $link.WorkingDirectory=Join-Path $env:USERPROFILE 'Tools\clism'; $link.Save()"
    if errorlevel 1 (
        echo 手動: "%CLISM_EXE%" のショートカットをスタートアップに作成してください。
        set "FAILED=1"
    )
) else (
    echo スキップ: CLISM64.EXE が見つかりません: "%CLISM_EXE%"
    echo 手動: CLISM を配置した後、このスクリプトを再実行してください。
    set "FAILED=1"
)

if "%FAILED%"=="1" exit /b 1
echo スタートアップ登録が完了しました。
exit /b 0
