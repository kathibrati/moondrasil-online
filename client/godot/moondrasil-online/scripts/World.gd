extends Node2D

const PLAYER_SCENE = preload("res://scenes/player/Player.tscn")
const DEFAULT_MAP_ID := "starter_village"

var player_state := PlayerState.new()
var map_definition: MapDefinition
var player: Node2D

@onready var gameplay_input: GameplayInput = $GameplayInput
@onready var targeting: TargetingController = $TargetingController
@onready var combat: CombatController = $CombatController
@onready var quests: QuestManager = $QuestManager
@onready var dialogs: DialogController = $DialogController
@onready var spawns: SpawnManager = $SpawnManager

func _ready():
	var world_data: Dictionary = get_tree().root.get_meta("enter_world", {})
	map_definition = MapCatalog.get_map(
		str(world_data.get("mapId", DEFAULT_MAP_ID))
	)

	_initialize_player_state(world_data)
	_bind_ui()
	_apply_map_definition()
	_spawn_player(world_data)
	_configure_controllers()
	_spawn_npcs()
	_configure_spawns()
	_connect_input()
	get_tree().root.remove_meta("enter_world")

func _initialize_player_state(world_data: Dictionary):
	player_state.character_id = str(world_data.get("characterId", ""))
	player_state.character_name = str(
		world_data.get("characterName", "Unknown")
	)

func _bind_ui():
	$PlayerPanel.bind(player_state)
	$InventoryPanel.bind(player_state)

func _apply_map_definition():
	$WorldTitle.text = map_definition.display_name
	$Background.position = map_definition.bounds.position
	$Background.size = map_definition.bounds.size
	if map_definition.environment_scene != null:
		$Environment.add_child(
			map_definition.environment_scene.instantiate()
		)

func _spawn_player(world_data: Dictionary):
	player = PLAYER_SCENE.instantiate()
	player.character_id = player_state.character_id
	player.position = Vector2(
		float(world_data.get("x", map_definition.default_player_spawn.x)),
		float(world_data.get("y", map_definition.default_player_spawn.y))
	)
	$Players.add_child(player)
	player.set_character_name(player_state.character_name)

func _configure_controllers():
	quests.configure(player_state, $QuestTracker)
	targeting.configure(player)
	combat.configure(targeting, player_state)
	dialogs.configure($DialogBox, quests)
	targeting.status_changed.connect(_show_target_status)
	combat.monster_defeated.connect(quests.record_monster_defeated)

func _spawn_npcs():
	for definition in map_definition.npc_definitions:
		var npc = definition.scene.instantiate()
		$Npcs.add_child(npc)
		npc.configure(definition)
		dialogs.register_npc(npc)

func _configure_spawns():
	spawns.monster_defeated.connect(combat.handle_monster_defeated)
	spawns.configure($Monsters, map_definition.spawn_rules)
	spawns.spawn_initial_monsters()

func _connect_input():
	gameplay_input.target_requested.connect(targeting.select_nearest)
	gameplay_input.attack_requested.connect(combat.attack_selected)
	gameplay_input.auto_attack_requested.connect(combat.start_auto_attack)
	gameplay_input.interact_requested.connect(dialogs.interact)
	gameplay_input.cancel_requested.connect(dialogs.cancel)
	gameplay_input.action_detected.connect(_show_target_status)

func _show_target_status(message: String):
	$Interface/TargetStatus.text = message
