$ErrorActionPreference = 'Stop'

$fontDirectory = Join-Path $env:LOCALAPPDATA 'Microsoft\Windows\Fonts'
$registryPath = 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts'
$versionFile = Join-Path $fontDirectory 'PlemolJP_NF.version'
$workDirectory = Join-Path (Join-Path $env:USERPROFILE 'Downloads\tmp') ('PlemolJP_NF_' + [guid]::NewGuid().ToString('N'))
$installed = $false

try {
    $release = Invoke-RestMethod 'https://api.github.com/repos/yuru7/PlemolJP/releases/latest'
    $asset = $release.assets | Where-Object { $_.name -match '^PlemolJP_NF_v[^/]+\.zip$' } | Select-Object -First 1
    if (-not $asset) { throw 'PlemolJP NF の配布 ZIP が見つかりません。' }

    if (Test-Path $versionFile) {
        $installedVersion = (Get-Content $versionFile -Raw).Trim()
        if ($installedVersion -eq $release.tag_name) {
            Write-Host "PlemolJP NF $installedVersion は導入済みです。"
            exit 0
        }
        $existingFonts = @(Get-ChildItem -Path $fontDirectory -File -Filter 'PlemolJP*NF*.ttf')
        if ($existingFonts.Count -gt 0) {
            throw "PlemolJP NF $installedVersion が導入済みです。$($release.tag_name) に更新する前に既存フォントを削除してください。"
        }
        Remove-Item -LiteralPath $versionFile
    }

    New-Item -ItemType Directory -Path $workDirectory -Force | Out-Null
    $archive = Join-Path $workDirectory $asset.name
    Write-Host "$($asset.name) をダウンロードしています..."
    Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $archive
    $extracted = Join-Path $workDirectory 'extracted'
    Expand-Archive -Path $archive -DestinationPath $extracted

    $fonts = @(Get-ChildItem -Path $extracted -Recurse -File -Filter '*.ttf' | Where-Object { $_.Name -match '^PlemolJP.*NF.*\.ttf$' })
    if ($fonts.Count -eq 0) { throw 'ZIP 内に PlemolJP NF のフォントが見つかりません。' }

    New-Item -ItemType Directory -Path $fontDirectory -Force | Out-Null
    if (-not (Test-Path $registryPath)) { New-Item -Path $registryPath -Force | Out-Null }
    foreach ($font in $fonts) {
        $destination = Join-Path $fontDirectory $font.Name
        if (Test-Path $destination) { throw "フォントが既にあります: $destination。PlemolJP NF を導入する前に削除してください。" }
    }
    Add-Type -Namespace Win32 -Name FontApi -MemberDefinition @'
[System.Runtime.InteropServices.DllImport("gdi32.dll", CharSet = System.Runtime.InteropServices.CharSet.Unicode)]
public static extern int AddFontResource(string path);
[System.Runtime.InteropServices.DllImport("user32.dll", CharSet = System.Runtime.InteropServices.CharSet.Unicode)]
public static extern IntPtr SendMessage(IntPtr hWnd, uint msg, IntPtr wParam, IntPtr lParam);
'@

    foreach ($font in $fonts) {
        $destination = Join-Path $fontDirectory $font.Name
        Copy-Item -LiteralPath $font.FullName -Destination $destination
        New-ItemProperty -Path $registryPath -Name "$($font.BaseName) (TrueType)" -Value $destination -PropertyType String -Force | Out-Null
        if ([Win32.FontApi]::AddFontResource($destination) -eq 0) {
            throw "Windows がフォントを読み込めませんでした: $destination"
        }
    }

    [void][Win32.FontApi]::SendMessage([IntPtr]0xffff, 0x001d, [IntPtr]::Zero, [IntPtr]::Zero)
    Set-Content -Path $versionFile -Value $release.tag_name -NoNewline
    $installed = $true
    Write-Host "PlemolJP NF のフォント $($fonts.Count) 件を導入しました。版: $($release.tag_name)"
} catch {
    Write-Host "エラー: $_"
    if (Test-Path (Join-Path $workDirectory 'extracted')) {
        Write-Host "手動: '$workDirectory\extracted' のフォントを導入してください。"
    }
    if ($asset -and (Test-Path (Join-Path $workDirectory $asset.name))) {
        Write-Host "        ZIP: '$workDirectory\$($asset.name)'"
    }
    exit 1
} finally {
    if ($installed -and (Test-Path $workDirectory)) { Remove-Item -LiteralPath $workDirectory -Recurse -Force }
}
