var payload = {
	"type": "PING"
}

websocket.send_text(
	JSON.stringify(payload)
)
