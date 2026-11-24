$ErrorActionPreference = 'Stop'

$configPath = Join-Path $env:USERPROFILE '.config\nvim'
$linkPath = Join-Path $env:LOCALAPPDATA 'nvim'

try {
    if (-not (Test-Path -LiteralPath (Join-Path $configPath 'init.lua') -PathType Leaf)) {
        throw "Neovim config is missing: $configPath\init.lua"
    }

    # Enumerate the parent so a broken junction is also detected.
    $existing = Get-ChildItem -LiteralPath $env:LOCALAPPDATA -Force |
        Where-Object { $_.Name -eq 'nvim' } |
        Select-Object -First 1
    if ($null -ne $existing) {
        if ($existing.LinkType -eq 'Junction') {
            $target = [IO.Path]::GetFullPath([string](@($existing.Target)[0])).TrimEnd('\')
            $expected = [IO.Path]::GetFullPath($configPath).TrimEnd('\')
            if ($target -eq $expected) {
                Write-Host "OK: $linkPath -> $configPath"
                exit 0
            }
            Write-Host "CONFLICT: Existing junction points to $target"
        } else {
            Write-Host "CONFLICT: $linkPath already exists (type: $($existing.LinkType), directory: $($existing.PSIsContainer))."
        }
        Write-Host "MANUAL: Inspect '$linkPath' and preserve any needed config before moving or removing it."
        Write-Host 'Then rerun this script. Existing contents were preserved.'
        exit 1
    }

    Write-Host "Creating junction: $linkPath -> $configPath"
    New-Item -ItemType Junction -Path $linkPath -Target $configPath | Out-Null
    Write-Host 'Neovim config junction created.'
} catch {
    Write-Host "ERROR: $_"
    Write-Host "MANUAL: After resolving the error, rerun '$PSCommandPath'."
    exit 1
}
