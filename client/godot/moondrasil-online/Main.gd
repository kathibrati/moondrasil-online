extends Control

@onready var connect_button = $VBoxContainer/ConnectButton
@onready var status_label = $VBoxContainer/StatusLabel

var websocket := WebSocketPeer.new()

func _ready():
	connect_button.pressed.connect(_on_connect_pressed)

func _process(_delta):
	websocket.poll()

	if websocket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		while websocket.get_available_packet_count() > 0:
			var message = websocket.get_packet().get_string_from_utf8()

			print("Received: ", message)

			status_label.text = message

func _on_connect_pressed():
	var error = websocket.connect_to_url(
		"ws://127.0.0.1:8090/ws"
	)

	if error == OK:
		status_label.text = "Connecting..."
	else:
		status_label.text = "Connection failed"
