class_name MapDefinition
extends Resource

var map_id: String = ""
var display_name: String = ""
var bounds: Rect2 = Rect2()
var default_player_spawn: Vector2 = Vector2.ZERO
var environment_scene: PackedScene
var npc_definitions: Array[Dictionary] = []
var spawn_rules: Array[SpawnRule] = []
