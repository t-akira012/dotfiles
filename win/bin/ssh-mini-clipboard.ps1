param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$SshArguments
)

$ErrorActionPreference = 'Stop'
$textPort = 2223
$imagePort = 2224
$servers = @(
    @{ Port = $textPort; Path = (Join-Path $PSScriptRoot 'host-clipboard-server.ps1') },
    @{ Port = $imagePort; Path = (Join-Path $PSScriptRoot 'host-clipboard-image-server.ps1') }
)

if (-not $SshArguments -or $SshArguments.Count -eq 0) {
    throw 'SSH destination is required (example: t-akira012@192.168.50.100)'
}

$processes = @()
try {
    foreach ($server in $servers) {
        # Fail early if another listener already owns this local port.
        $guard = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, $server.Port)
        $guard.Start()
        $guard.Stop()

        $serverCommand = "& '$($server.Path.Replace("'", "''"))' -Port $($server.Port)"
        $encodedCommand = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($serverCommand))
        $process = Start-Process -FilePath 'powershell.exe' -ArgumentList @('-NoProfile', '-STA', '-EncodedCommand', $encodedCommand) -WindowStyle Hidden -PassThru
        $processes += $process

        $ready = $false
        for ($i = 0; $i -lt 40; $i++) {
            if ($process.HasExited) {
                throw "Clipboard server on port $($server.Port) exited before it started"
            }
            $probe = [System.Net.Sockets.TcpClient]::new()
            try {
                $probe.Connect('127.0.0.1', $server.Port)
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
            throw "Clipboard server on port $($server.Port) did not start"
        }
    }

    # The remote helper marks this SSH TTY while preserving the normal shell
    # and any tmux session the user chooses to attach.
    & ssh.exe -tt -o ExitOnForwardFailure=yes -R "127.0.0.1:${textPort}:127.0.0.1:${textPort}" -R "127.0.0.1:${imagePort}:127.0.0.1:${imagePort}" @SshArguments '~/bin/ssh-clipboard-shell'
    exit $LASTEXITCODE
}
finally {
    foreach ($process in $processes) {
        if (-not $process.HasExited) {
            Stop-Process -Id $process.Id
        }
        $process.Dispose()
    }
}
