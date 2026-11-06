@echo off
setlocal

where winget >nul 2>nul
if errorlevel 1 (
    echo ERROR: winget is not available.
    exit /b 1
)

set "FAILED=0"
call :install "Microsoft.VCRedist.2015+.x64"
if errorlevel 1 set "FAILED=1"
call :install "Microsoft.VCRedist.2015+.x86"
if errorlevel 1 set "FAILED=1"
call :install "Mozilla.Firefox"
if errorlevel 1 set "FAILED=1"
call :install "Google.JapaneseIME"
if errorlevel 1 set "FAILED=1"

echo.
if "%FAILED%"=="1" (
    echo Some installations failed.
    exit /b 1
)
echo All installations completed.
exit /b 0

:install
echo.
echo Installing %~1 ...
winget install --id "%~1" --exact --source winget --accept-source-agreements --accept-package-agreements
if errorlevel 1 (
    echo ERROR: %~1 failed.
    exit /b 1
)
echo Completed %~1.
exit /b 0
