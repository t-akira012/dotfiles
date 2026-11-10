```
curl -L raw.githubusercontent.com/t-akira012/dotfiles/main/dl.sh | bash
```

Windows PowerShell から `win/dl.bat` をダウンロードして実行する:

```powershell
$p=Join-Path $env:TEMP 'dotfiles-dl.bat'; curl.exe -fL 'https://raw.githubusercontent.com/t-akira012/dotfiles/main/win/dl.bat' -o $p; if ($LASTEXITCODE -ne 0) { throw 'dl.bat download failed' }; & $p
```
