extends Node2D

const PLAYER_SCENE = preload("res://scenes/player/Player.tscn")
const NPC_SCENE = preload("res://scenes/npc/Npc.tscn")

var active_npc = null
var player_state := PlayerState.new()
var active_quests: Dictionary = {}
var completed_quests: Dictionary = {}

func _ready():
	$DialogBox.action_pressed.connect(_on_dialog_action_pressed)
	var world_data: Dictionary = get_tree().root.get_meta("enter_world", {})
	_initialize_player_state(world_data)
	$PlayerPanel.bind(player_state)
	$InventoryPanel.bind(player_state)
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

func _initialize_player_state(world_data: Dictionary):
	player_state.character_id = str(world_data.get("characterId", ""))
	player_state.character_name = str(world_data.get("characterName", "Unknown"))

func _spawn_player(world_data: Dictionary):
	var player = PLAYER_SCENE.instantiate()
	player.character_id = player_state.character_id
	player.position = Vector2(
		float(world_data.get("x", 0)),
		float(world_data.get("y", 0))
	)

	$Players.add_child(player)
	player.set_character_name(player_state.character_name)

func _spawn_village_elder():
	var village_elder = NPC_SCENE.instantiate()
	village_elder.position = Vector2(350, 200)
	var welcome_quest = QuestData.create(
		"welcome_to_moondrasil",
		"Welcome to Moondrasil",
		"Talk to the Village Elder.",
		"Learn the basics of the world."
	)
	welcome_quest.reward_experience = 100
	welcome_quest.reward_gold = 10
	welcome_quest.reward_items.append(
		ItemData.create("wooden_sword", "Wooden Sword")
	)

	$Npcs.add_child(village_elder)
	village_elder.set_npc_name("Village Elder")
	village_elder.set_interaction_text(
		"Welcome to Moondrasil, traveler. Can you help me with something?"
	)
	village_elder.set_quest_offer(welcome_quest)
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
		var quest = active_npc.quest_offer
		var dialog_text = active_npc.interaction_text
		var action_label = ""

		if quest != null:
			if completed_quests.has(quest.id):
				dialog_text = "Thank you for helping me. Welcome to Moondrasil."
			elif active_quests.has(quest.id):
				dialog_text = "You have learned the basics. Let us complete your quest."
				action_label = "Complete"
			else:
				action_label = "Accept"

		$DialogBox.open_dialog(active_npc.npc_name, dialog_text, action_label)

func _on_dialog_action_pressed():
	if not active_npc or active_npc.quest_offer == null:
		return

	var quest: QuestData = active_npc.quest_offer

	if completed_quests.has(quest.id):
		return

	if active_quests.has(quest.id):
		_complete_quest(active_quests[quest.id])
	else:
		_accept_quest(quest)

func _accept_quest(quest: QuestData):
	var quest_state = QuestState.create(quest)
	quest_state.status = QuestState.Status.ACTIVE
	active_quests[quest.id] = quest_state
	$QuestTracker.add_active_quest(quest_state)
	_close_dialog()

func _complete_quest(quest_state: QuestState):
	var quest = quest_state.quest
	quest_state.status = QuestState.Status.COMPLETED
	active_quests.erase(quest.id)
	completed_quests[quest.id] = quest_state

	player_state.grant_quest_rewards(quest)
	$QuestTracker.complete_quest(quest_state)
	_close_dialog()

func _close_dialog():
	$DialogBox.close_dialog()

	if active_npc:
		$DialogBox.show_hint()
