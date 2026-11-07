@echo off
setlocal

set "KEYHAC_EXE=%USERPROFILE%\Tools\keyhac\Keyhac.exe"
set "CLISM_EXE=%USERPROFILE%\Tools\clism\CLISM64.EXE"

if not exist "%KEYHAC_EXE%" (
    echo ERROR: Keyhac.exe not found: %KEYHAC_EXE%
    exit /b 1
)
if not exist "%CLISM_EXE%" (
    echo ERROR: CLISM64.EXE not found: %CLISM_EXE%
    exit /b 1
)

echo Creating Keyhac startup shortcut ...
powershell -NoProfile -Command "$ErrorActionPreference='Stop'; $shell=New-Object -ComObject WScript.Shell; $dir=[Environment]::GetFolderPath('Startup'); $link=$shell.CreateShortcut([IO.Path]::Combine($dir,'Keyhac.lnk')); $link.TargetPath=Join-Path $env:USERPROFILE 'Tools\keyhac\Keyhac.exe'; $link.WorkingDirectory=Join-Path $env:USERPROFILE 'Tools\keyhac'; $link.Save()"
if errorlevel 1 exit /b 1

echo Creating CLISM excellent startup shortcut ...
powershell -NoProfile -Command "$ErrorActionPreference='Stop'; $shell=New-Object -ComObject WScript.Shell; $dir=[Environment]::GetFolderPath('Startup'); $link=$shell.CreateShortcut([IO.Path]::Combine($dir,'CLISM excellent.lnk')); $link.TargetPath=Join-Path $env:USERPROFILE 'Tools\clism\CLISM64.EXE'; $link.WorkingDirectory=Join-Path $env:USERPROFILE 'Tools\clism'; $link.Save()"
if errorlevel 1 exit /b 1

echo Startup shortcuts created.
exit /b 0
