@echo off
setlocal

set "KEYHAC_EXE=%USERPROFILE%\Tools\keyhac\Keyhac.exe"
set "CLISM_EXE=%USERPROFILE%\Tools\clism\CLISM64.EXE"
set "FAILED=0"

if exist "%KEYHAC_EXE%" (
    echo Creating Keyhac startup shortcut ...
    powershell -NoProfile -Command "$ErrorActionPreference='Stop'; $shell=New-Object -ComObject WScript.Shell; $dir=[Environment]::GetFolderPath('Startup'); $link=$shell.CreateShortcut([IO.Path]::Combine($dir,'Keyhac.lnk')); $link.TargetPath=Join-Path $env:USERPROFILE 'Tools\keyhac\Keyhac.exe'; $link.WorkingDirectory=Join-Path $env:USERPROFILE 'Tools\keyhac'; $link.Save()"
    if errorlevel 1 (
        echo MANUAL: Create a Startup shortcut for "%KEYHAC_EXE%".
        set "FAILED=1"
    )
) else (
    echo SKIP: Keyhac.exe not found: "%KEYHAC_EXE%"
    echo MANUAL: After placing Keyhac, run this script again to create its Startup shortcut.
    set "FAILED=1"
)

if exist "%CLISM_EXE%" (
    echo Creating CLISM excellent startup shortcut ...
    powershell -NoProfile -Command "$ErrorActionPreference='Stop'; $shell=New-Object -ComObject WScript.Shell; $dir=[Environment]::GetFolderPath('Startup'); $link=$shell.CreateShortcut([IO.Path]::Combine($dir,'CLISM excellent.lnk')); $link.TargetPath=Join-Path $env:USERPROFILE 'Tools\clism\CLISM64.EXE'; $link.WorkingDirectory=Join-Path $env:USERPROFILE 'Tools\clism'; $link.Save()"
    if errorlevel 1 (
        echo MANUAL: Create a Startup shortcut for "%CLISM_EXE%".
        set "FAILED=1"
    )
) else (
    echo SKIP: CLISM64.EXE not found: "%CLISM_EXE%"
    echo MANUAL: After placing CLISM, run this script again to create its Startup shortcut.
    set "FAILED=1"
)

if "%FAILED%"=="1" exit /b 1
echo Startup shortcuts created.
exit /b 0
