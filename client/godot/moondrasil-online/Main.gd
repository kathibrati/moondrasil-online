extends Control

@onready var connect_button = $VBoxContainer/ConnectButton
@onready var status_label = $VBoxContainer/StatusLabel
@onready var ping_button = $VBoxContainer/PingButton
@onready var login_button = $VBoxContainer/LoginButton
@onready var get_characters_button = $VBoxContainer/GetCharactersButton
@onready var select_basti_button = $VBoxContainer/SelectBastiButton

var websocket := WebSocketPeer.new()

func _ready():
	connect_button.pressed.connect(_on_connect_pressed)
	ping_button.pressed.connect(_on_ping_pressed)
	login_button.pressed.connect(_on_login_pressed)
	get_characters_button.pressed.connect(_on_get_characters_pressed)
	select_basti_button.pressed.connect(_on_select_basti_pressed)

func _process(_delta):
	websocket.poll()

	if websocket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		while websocket.get_available_packet_count() > 0:
			var message = websocket.get_packet().get_string_from_utf8()

			print("Received: ", message)
			_display_message(message)

func _on_connect_pressed():
	var error = websocket.connect_to_url(
		"ws://127.0.0.1:8090/ws"
	)

	if error == OK:
		status_label.text = "Connecting..."
	else:
		status_label.text = "Connection failed"
		
func _on_ping_pressed():
	var payload = {
		"type": "PING"
	}

	_send_message(payload)

func _on_login_pressed():
	var payload = {
		"type": "LOGIN",
		"username": "test",
		"password": "test"
	}

	_send_message(payload)

func _on_get_characters_pressed():
	_send_message({
		"type": "GET_CHARACTERS"
	})

func _on_select_basti_pressed():
	_send_message({
		"type": "SELECT_CHARACTER",
		"characterId": "1"
	})

func _send_message(payload: Dictionary):
	if websocket.get_ready_state() != WebSocketPeer.STATE_OPEN:
		status_label.text = "Connect to the gateway first"
		return

	websocket.send_text(JSON.stringify(payload))

func _display_message(message: String):
	var payload = JSON.parse_string(message)

	if typeof(payload) != TYPE_DICTIONARY:
		status_label.text = "Invalid message from gateway"
		return

	if payload.get("type") == "CHARACTER_LIST":
		var character_names: Array[String] = []

		for character in payload.get("characters", []):
			var character_id = str(character.get("id", ""))
			var character_name = str(character.get("name", ""))
			character_names.append("%s: %s" % [character_id, character_name])

		status_label.text = "Characters: " + ", ".join(character_names)
		return

	if payload.get("type") == "ENTER_WORLD":
		var world_data = {
			"characterId": str(payload.get("characterId", "")),
			"characterName": str(payload.get("characterName", "")),
			"x": float(payload.get("x", 0)),
			"y": float(payload.get("y", 0))
		}

		get_tree().root.set_meta("enter_world", world_data)
		get_tree().change_scene_to_file("res://scenes/World.tscn")
		return

	status_label.text = message
