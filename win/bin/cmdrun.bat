@echo off
chcp 65001
set PATH=%PATH%;%USERPROFILE%\bin;%USERPROFILE%\exe;%USERPROFILE%\exe\git-bash\bin;%USERPROFILE%\exe\git-bash\usr\bin;%USERPROFILE%\exe\nvim-win64\bin
doskey cd=_cd.bat $*
cmd.exe
