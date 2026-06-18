# Gateway WebSocket Test

## Endpoint

```text
ws://127.0.0.1:8090/ws
```

## Voraussetzung

Gateway muss laufen:

```powershell
.\gradlew.bat :backend:game-gateway-service:run
```

Health Check:

```text
http://127.0.0.1:8090/health
```

Erwartete Antwort:

```text
game-gateway-service is running
```

## Automatischer Test per PowerShell

Script:

```text
scripts/websocket-test.ps1
```

Ausführen aus dem Repository Root:

```powershell
.\scripts\websocket-test.ps1
```

Falls PowerShell Scripts blockiert:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\scripts\websocket-test.ps1
```

`Scope Process` gilt nur für die aktuelle PowerShell-Session und ist nach dem Schließen des Fensters wieder weg.

## Erwartete Ausgabe

```text
Connecting to Gateway...
Connected.
Received:
{"type":"CONNECTED","message":"Welcome to Moondrasil"}

Echo Response:
{"type":"ECHO","message":"hello-moondrasil"}

Test completed.
```

## Manueller Test mit PowerShell

Verbindung öffnen:

```powershell
$ws = [System.Net.WebSockets.ClientWebSocket]::new()
$uri = [Uri]"ws://127.0.0.1:8090/ws"
$ws.ConnectAsync($uri, [Threading.CancellationToken]::None).GetAwaiter().GetResult()
```

Welcome Message lesen:

```powershell
$buffer = New-Object byte[] 1024
$result = $ws.ReceiveAsync([ArraySegment[byte]]::new($buffer), [Threading.CancellationToken]::None).GetAwaiter().GetResult()
[Text.Encoding]::UTF8.GetString($buffer, 0, $result.Count)
```

Nachricht senden:

```powershell
$message = [Text.Encoding]::UTF8.GetBytes("hello")
$ws.SendAsync([ArraySegment[byte]]::new($message), [System.Net.WebSockets.WebSocketMessageType]::Text, $true, [Threading.CancellationToken]::None).GetAwaiter().GetResult()
```

Echo lesen:

```powershell
$buffer = New-Object byte[] 1024
$result = $ws.ReceiveAsync([ArraySegment[byte]]::new($buffer), [Threading.CancellationToken]::None).GetAwaiter().GetResult()
[Text.Encoding]::UTF8.GetString($buffer, 0, $result.Count)
```

Verbindung schließen:

```powershell
$ws.Dispose()
```

## Zweck

Dieser Test prüft aktuell nur:

- WebSocket-Verbindung kann aufgebaut werden
- Gateway sendet eine Welcome Message
- Client kann Text senden
- Gateway sendet Echo Response zurück

Noch nicht enthalten:

- Authentifizierung
- Session Handling
- JSON Message Routing
- Kafka Events
- Datenbankzugriff