class_name SpawnRule
extends Resource

var spawn_id: String = ""
var monster_type: String = ""
var monster_id: String = ""
var display_name: String = ""
var monster_scene: PackedScene
var max_alive: int = 1
var respawn_seconds: float = 5.0
var spawn_area: Rect2 = Rect2()
var min_distance_to_entities: float = 48.0
var max_spawn_attempts: int = 20
var max_hp: int = 1
var experience_reward: int = 0
var gold_reward: int = 0

static func create(
	id: String,
	type: String,
	entity_id: String,
	name: String,
	scene: PackedScene,
	alive_limit: int,
	respawn_delay: float,
	area: Rect2,
	min_entity_distance: float,
	spawn_attempt_limit: int,
	hit_points: int,
	reward_experience: int,
	reward_gold: int
) -> SpawnRule:
	var rule := SpawnRule.new()
	rule.spawn_id = id
	rule.monster_type = type
	rule.monster_id = entity_id
	rule.display_name = name
	rule.monster_scene = scene
	rule.max_alive = alive_limit
	rule.respawn_seconds = respawn_delay
	rule.spawn_area = area
	rule.min_distance_to_entities = min_entity_distance
	rule.max_spawn_attempts = spawn_attempt_limit
	rule.max_hp = hit_points
	rule.experience_reward = reward_experience
	rule.gold_reward = reward_gold
	return rule

static func from_config(config: Dictionary, scene: PackedScene) -> SpawnRule:
	var rule := SpawnRule.new()
	rule.spawn_id = str(config.get("spawnId", ""))
	rule.monster_type = str(config.get("monsterType", ""))
	rule.monster_id = str(config.get("monsterId", ""))
	rule.display_name = str(config.get("displayName", "Monster"))
	rule.monster_scene = scene
	rule.max_alive = int(config.get("maxAlive", 1))
	rule.respawn_seconds = float(config.get("respawnSeconds", 5.0))
	rule.spawn_area = config.get("spawnArea", Rect2())
	rule.min_distance_to_entities = float(
		config.get("minDistanceToEntities", 48.0)
	)
	rule.max_spawn_attempts = int(config.get("maxSpawnAttempts", 20))
	rule.max_hp = int(config.get("maxHp", 1))
	rule.experience_reward = int(config.get("experienceReward", 0))
	rule.gold_reward = int(config.get("goldReward", 0))
	return rule
