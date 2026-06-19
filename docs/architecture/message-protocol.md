# Message Protocol

Moondrasil Online uses JSON messages over WebSocket.

## General Structure

Every message must contain a `type` field.

```json
{
  "type": "PING"
}
```

## Client to Server Messages

### PING

Checks whether the gateway is reachable.

```json
{
  "type": "PING"
}
```

### LOGIN

Requests a login through the gateway.

```json
{
  "type": "LOGIN",
  "username": "test",
  "password": "test"
}
```

### GET_CHARACTERS

Requests the character list.

```json
{
  "type": "GET_CHARACTERS"
}
```

### SELECT_CHARACTER

Selects a character and requests entry into the world.

```json
{
  "type": "SELECT_CHARACTER",
  "characterId": "1"
}
```

## Server to Client Messages

### CONNECTED

Sent by the gateway after a successful WebSocket connection.

```json
{
  "type": "CONNECTED",
  "message": "Welcome to Moondrasil"
}
```

### PONG

Response to `PING`.

```json
{
  "type": "PONG"
}
```

### LOGIN_SUCCESS

Sent when login was successful.

```json
{
  "type": "LOGIN_SUCCESS",
  "username": "test"
}
```

### LOGIN_FAILED

Sent when login failed.

```json
{
  "type": "LOGIN_FAILED",
  "reason": "Invalid credentials"
}
```

### CHARACTER_LIST

Returns the available characters.

```json
{
  "type": "CHARACTER_LIST",
  "characters": [
    {
      "id": "1",
      "name": "Basti"
    },
    {
      "id": "2",
      "name": "Kathleen"
    }
  ]
}
```

### ENTER_WORLD

Sent after a known character is selected.

```json
{
  "type": "ENTER_WORLD",
  "characterId": "1",
  "characterName": "Basti",
  "x": 100,
  "y": 200
}
```

### ERROR

Sent when the gateway cannot process a message.

Unsupported message type:

```json
{
  "type": "ERROR",
  "reason": "Unknown message type"
}
```

Unknown character:

```json
{
  "type": "ERROR",
  "errorCode": "CHARACTER_NOT_FOUND"
}
```
