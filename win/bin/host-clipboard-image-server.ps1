param([int]$Port = 2224)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Windows.Forms
$listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, $Port)
$listener.Start()

try {
    while ($true) {
        $client = $listener.AcceptTcpClient()
        try {
            $image = [System.Windows.Forms.Clipboard]::GetImage()
            if ($null -ne $image) {
                try {
                    $buffer = [System.IO.MemoryStream]::new()
                    try {
                        $image.Save($buffer, [System.Drawing.Imaging.ImageFormat]::Png)
                        $bytes = $buffer.ToArray()
                        $stream = $client.GetStream()
                        $stream.Write($bytes, 0, $bytes.Length)
                    }
                    finally {
                        $buffer.Dispose()
                    }
                }
                finally {
                    $image.Dispose()
                }
            }
        }
        catch {
            # The readiness probe disconnects immediately; leave later reads usable.
        }
        finally {
            $client.Dispose()
        }
    }
}
finally {
    $listener.Stop()
}
