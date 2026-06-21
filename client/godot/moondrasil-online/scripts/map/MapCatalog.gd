class_name MapCatalog
extends RefCounted

const NPC_SCENE = preload("res://scenes/npc/Npc.tscn")
const MONSTER_SCENE = preload("res://scenes/monster/Monster.tscn")

static func get_map(map_id: String) -> MapDefinition:
	match map_id:
		"starter_village":
			return _create_starter_village()
		_:
			return _create_starter_village()

static func _create_starter_village() -> MapDefinition:
	var map := MapDefinition.new()
	map.map_id = "starter_village"
	map.display_name = "Moondrasil World"
	map.bounds = Rect2(0, 0, 1152, 648)
	map.default_player_spawn = Vector2(120, 320)
	map.npc_definitions.append({
		"scene": NPC_SCENE,
		"position": Vector2(350, 100),
		"display_name": "Village Elder",
		"quest": QuestCatalog.create_welcome_quest(),
		"offer_dialog": (
			"Welcome to Moondrasil, traveler.\n\n"
			+ "Use WASD to move.\n"
			+ "Press Tab or right-click to select the Moon Slime.\n"
			+ "Press 1 or right-click the Moon Slime to attack.\n"
			+ "Defeat one Moon Slime, then come back to me."
		),
		"active_dialog": "Defeat one Moon Slime, then come back to me.",
		"ready_dialog": (
			"You defeated the Moon Slime. You are ready for the road ahead."
		),
		"completed_dialog": (
			"Thank you for helping me. Welcome to Moondrasil."
		)
	})
	map.spawn_rules.append(SpawnRule.from_config({
		"spawnId": "starter_moon_slimes",
		"monsterType": "MOON_SLIME",
		"monsterId": "moon_slime",
		"displayName": "Moon Slime",
		"maxAlive": 3,
		"respawnSeconds": 5.0,
		"spawnArea": Rect2(24, 24, 1104, 600),
		"minDistanceToEntities": 56.0,
		"maxSpawnAttempts": 30,
		"maxHp": 10,
		"experienceReward": 25,
		"goldReward": 2
	}, MONSTER_SCENE))
	return map
