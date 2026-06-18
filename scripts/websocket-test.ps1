Write-Host "Connecting to Gateway..."

$ws = [System.Net.WebSockets.ClientWebSocket]::new()
$uri = [Uri]"ws://127.0.0.1:8090/ws"

$ws.ConnectAsync(
    $uri,
    [Threading.CancellationToken]::None
).GetAwaiter().GetResult()

Write-Host "Connected."

$buffer = New-Object byte[] 1024

# Welcome Message
$result = $ws.ReceiveAsync(
    [ArraySegment[byte]]::new($buffer),
    [Threading.CancellationToken]::None
).GetAwaiter().GetResult()

$welcome = [Text.Encoding]::UTF8.GetString(
    $buffer,
    0,
    $result.Count
)

Write-Host "Received:"
Write-Host $welcome

# Echo Test
$message = "hello-moondrasil"
$messageBytes = [Text.Encoding]::UTF8.GetBytes($message)

$ws.SendAsync(
    [ArraySegment[byte]]::new($messageBytes),
    [System.Net.WebSockets.WebSocketMessageType]::Text,
    $true,
    [Threading.CancellationToken]::None
).GetAwaiter().GetResult()

$result = $ws.ReceiveAsync(
    [ArraySegment[byte]]::new($buffer),
    [Threading.CancellationToken]::None
).GetAwaiter().GetResult()

$response = [Text.Encoding]::UTF8.GetString(
    $buffer,
    0,
    $result.Count
)

Write-Host ""
Write-Host "Echo Response:"
Write-Host $response

$ws.Dispose()

Write-Host ""
Write-Host "Test completed."