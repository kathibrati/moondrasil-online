extends Node2D

const PLAYER_SCENE = preload("res://scenes/player/Player.tscn")
const NPC_SCENE = preload("res://scenes/npc/Npc.tscn")

var active_npc = null

func _ready():
	var world_data: Dictionary = get_tree().root.get_meta("enter_world", {})
	_spawn_player(world_data)
	_spawn_village_elder()
	get_tree().root.remove_meta("enter_world")

func _input(event):
	if not (event is InputEventKey) or not event.pressed or event.echo:
		return

	if event.keycode == KEY_E and active_npc:
		_toggle_dialog()
		get_viewport().set_input_as_handled()
	elif event.keycode == KEY_ESCAPE and $DialogBox.is_dialog_open():
		_close_dialog()
		get_viewport().set_input_as_handled()

func _spawn_player(world_data: Dictionary):
	var player = PLAYER_SCENE.instantiate()
	player.character_id = str(world_data.get("characterId", ""))
	player.position = Vector2(
		float(world_data.get("x", 0)),
		float(world_data.get("y", 0))
	)

	$Players.add_child(player)
	player.set_character_name(str(world_data.get("characterName", "Unknown")))

func _spawn_village_elder():
	var village_elder = NPC_SCENE.instantiate()
	village_elder.position = Vector2(350, 200)

	$Npcs.add_child(village_elder)
	village_elder.set_npc_name("Village Elder")
	village_elder.set_interaction_text("Welcome to Moondrasil, traveler.")
	village_elder.interaction_available.connect(_on_npc_interaction_available)
	village_elder.interaction_unavailable.connect(_on_npc_interaction_unavailable)

func _on_npc_interaction_available(npc):
	active_npc = npc
	$DialogBox.show_hint()

func _on_npc_interaction_unavailable(npc):
	if active_npc != npc:
		return

	active_npc = null
	$DialogBox.hide_hint()
	$DialogBox.close_dialog()

func _toggle_dialog():
	if $DialogBox.is_dialog_open():
		_close_dialog()
	else:
		$DialogBox.open_dialog(active_npc.npc_name, active_npc.interaction_text)

func _close_dialog():
	$DialogBox.close_dialog()

	if active_npc:
		$DialogBox.show_hint()
