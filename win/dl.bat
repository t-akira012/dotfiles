@echo off
setlocal

set TEMP_DIR=%TEMP%\dotfiles_%RANDOM%
set ZIP_URL=https://github.com/t-akira012/dotfiles/archive/refs/heads/main.zip

echo Downloading dotfiles ...
mkdir "%TEMP_DIR%" 2>nul
curl -sL "%ZIP_URL%" -o "%TEMP_DIR%\dotfiles.zip"
tar xvf "%TEMP_DIR%\dotfiles.zip" -C "%TEMP_DIR%"

set SRC=%TEMP_DIR%\dotfiles-main\win

echo.
echo Copying bin ...
xcopy /s /y "%SRC%\bin" "%USERPROFILE%\bin\"

echo.
echo Copying keyhac\config.py ...
mkdir "%USERPROFILE%\keyhac" 2>nul
copy /y "%SRC%\keyhac\config.py" "%USERPROFILE%\keyhac\config.py"

echo.
echo Running install.bat ...
call "%SRC%\exe\install.bat"

rd /s /q "%TEMP_DIR%"
echo.
echo All done!
