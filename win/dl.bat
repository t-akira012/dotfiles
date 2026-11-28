@echo off
setlocal

set "LAUNCH_DIR=%TEMP%\dotfiles_setup_%RANDOM%_%RANDOM%"
set "SETUP_URL=https://raw.githubusercontent.com/t-akira012/dotfiles/main/win/setup.bat"

echo Preparing setup download: "%LAUNCH_DIR%"
if exist "%LAUNCH_DIR%" goto :fail
mkdir "%LAUNCH_DIR%"
if errorlevel 1 goto :fail

echo Downloading latest setup.bat ...
"%SystemRoot%\System32\curl.exe" -fL "%SETUP_URL%" -o "%LAUNCH_DIR%\setup.bat"
if errorlevel 1 goto :fail

echo Running latest setup.bat ...
call "%LAUNCH_DIR%\setup.bat"
set "SETUP_RESULT=%ERRORLEVEL%"
if not "%SETUP_RESULT%"=="0" (
    echo Setup failed or manual steps remain. Downloaded script: "%LAUNCH_DIR%\setup.bat"
    exit /b %SETUP_RESULT%
)

rd /s /q "%LAUNCH_DIR%"
if errorlevel 1 (
    echo WARNING: Could not remove temporary setup directory: "%LAUNCH_DIR%"
)
exit /b 0

:fail
echo ERROR: Could not download setup.bat. Setup was not run.
echo Temporary path: "%LAUNCH_DIR%"
exit /b 1
