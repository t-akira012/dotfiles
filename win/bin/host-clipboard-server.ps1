param([int]$Port = 2223)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Windows.Forms
$listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, $Port)
$listener.Start()

try {
    while ($true) {
        $client = $listener.AcceptTcpClient()
        try {
            $text = [System.Windows.Forms.Clipboard]::GetText().Replace("`r`n", "`n")
            $bytes = [System.Text.Encoding]::UTF8.GetBytes($text)
            $stream = $client.GetStream()
            $stream.Write($bytes, 0, $bytes.Length)
        }
        finally {
            $client.Dispose()
        }
    }
}
finally {
    $listener.Stop()
}
