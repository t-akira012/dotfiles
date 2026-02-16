@echo off
for %%i in (%*) do (
    powershell -NoProfile -Command "Add-Type -AssemblyName Microsoft.VisualBasic; $p='%%~fi'; if(Test-Path $p -PathType Container){[Microsoft.VisualBasic.FileIO.FileSystem]::DeleteDirectory($p,'OnlyErrorDialogs','SendToRecycleBin')}else{[Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($p,'OnlyErrorDialogs','SendToRecycleBin')}"
)
