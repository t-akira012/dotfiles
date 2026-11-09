$ErrorActionPreference = 'Stop'

$fontDirectory = Join-Path $env:LOCALAPPDATA 'Microsoft\Windows\Fonts'
$registryPath = 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts'
$versionFile = Join-Path $fontDirectory 'PlemolJP_NF.version'
$workDirectory = Join-Path (Join-Path $env:USERPROFILE 'Downloads\tmp') ('PlemolJP_NF_' + [guid]::NewGuid().ToString('N'))
$installed = $false

try {
    $release = Invoke-RestMethod 'https://api.github.com/repos/yuru7/PlemolJP/releases/latest'
    $asset = $release.assets | Where-Object { $_.name -match '^PlemolJP_NF_v[^/]+\.zip$' } | Select-Object -First 1
    if (-not $asset) { throw 'PlemolJP NF release ZIP was not found.' }

    if (Test-Path $versionFile) {
        $installedVersion = (Get-Content $versionFile -Raw).Trim()
        if ($installedVersion -eq $release.tag_name) {
            Write-Host "PlemolJP NF $installedVersion is already installed."
            exit 0
        }
        $existingFonts = @(Get-ChildItem -Path $fontDirectory -File -Filter 'PlemolJP*NF*.ttf')
        if ($existingFonts.Count -gt 0) {
            throw "PlemolJP NF $installedVersion is installed. Remove the existing fonts before updating to $($release.tag_name)."
        }
        Remove-Item -LiteralPath $versionFile
    }

    New-Item -ItemType Directory -Path $workDirectory -Force | Out-Null
    $archive = Join-Path $workDirectory $asset.name
    Write-Host "Downloading $($asset.name) ..."
    Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $archive
    $extracted = Join-Path $workDirectory 'extracted'
    Expand-Archive -Path $archive -DestinationPath $extracted

    $fonts = @(Get-ChildItem -Path $extracted -Recurse -File -Filter '*.ttf' | Where-Object { $_.Name -match '^PlemolJP.*NF.*\.ttf$' })
    if ($fonts.Count -eq 0) { throw 'No PlemolJP NF font files were found in the ZIP.' }

    New-Item -ItemType Directory -Path $fontDirectory -Force | Out-Null
    if (-not (Test-Path $registryPath)) { New-Item -Path $registryPath -Force | Out-Null }
    foreach ($font in $fonts) {
        $destination = Join-Path $fontDirectory $font.Name
        if (Test-Path $destination) { throw "Font already exists: $destination. Remove it before installing PlemolJP NF." }
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
            throw "Windows could not load font: $destination"
        }
    }

    [void][Win32.FontApi]::SendMessage([IntPtr]0xffff, 0x001d, [IntPtr]::Zero, [IntPtr]::Zero)
    Set-Content -Path $versionFile -Value $release.tag_name -NoNewline
    $installed = $true
    Write-Host "Installed $($fonts.Count) PlemolJP NF font files ($($release.tag_name))."
} catch {
    Write-Host "ERROR: $_"
    if (Test-Path (Join-Path $workDirectory 'extracted')) {
        Write-Host "MANUAL: Install the PlemolJP NF fonts from '$workDirectory\extracted'."
    }
    if ($asset -and (Test-Path (Join-Path $workDirectory $asset.name))) {
        Write-Host "        ZIP: '$workDirectory\$($asset.name)'"
    }
    exit 1
} finally {
    if ($installed -and (Test-Path $workDirectory)) { Remove-Item -LiteralPath $workDirectory -Recurse -Force }
}
