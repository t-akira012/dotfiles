param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$SshArguments
)

$ErrorActionPreference = 'Stop'
$port = 2223
$server = Join-Path $PSScriptRoot 'host-clipboard-server.ps1'

if ($SshArguments.Count -eq 0) {
    $SshArguments = @('mini')
}

# Reserve the port briefly to fail early if another listener already owns it.
$guard = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, $port)
$guard.Start()
$guard.Stop()

$serverCommand = "& '$($server.Replace("'", "''"))' -Port $port"
$encodedCommand = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($serverCommand))
$process = Start-Process -FilePath 'powershell.exe' -ArgumentList @('-NoProfile', '-STA', '-EncodedCommand', $encodedCommand) -WindowStyle Hidden -PassThru

try {
    $ready = $false
    for ($i = 0; $i -lt 40; $i++) {
        if ($process.HasExited) {
            throw 'Clipboard server exited before it started'
        }
        $probe = [System.Net.Sockets.TcpClient]::new()
        try {
            $probe.Connect('127.0.0.1', $port)
            $ready = $true
            break
        }
        catch [System.Net.Sockets.SocketException] {
            Start-Sleep -Milliseconds 100
        }
        finally {
            $probe.Dispose()
        }
    }
    if (-not $ready) {
        throw 'Clipboard server did not start'
    }

    # The remote helper marks this SSH TTY while preserving the normal shell
    # and any tmux session the user chooses to attach.
    & ssh.exe -tt -o ExitOnForwardFailure=yes -R "127.0.0.1:${port}:127.0.0.1:${port}" @SshArguments '~/bin/ssh-clipboard-shell'
    exit $LASTEXITCODE
}
finally {
    if (-not $process.HasExited) {
        Stop-Process -Id $process.Id
    }
    $process.Dispose()
}
