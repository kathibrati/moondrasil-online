class_name SpawnManager
extends Node

signal monster_spawned(monster: Monster)
signal monster_defeated(
	monster: Monster,
	spawn_id: String,
	monster_type: String,
	monster_id: String,
	display_name: String,
	experience_reward: int,
	gold_reward: int
)

var monster_container: Node2D
var rules: Dictionary = {}
var alive_by_spawn: Dictionary = {}
var random := RandomNumberGenerator.new()

func configure(container: Node2D, spawn_rules: Array):
	monster_container = container
	rules.clear()
	alive_by_spawn.clear()
	random.randomize()

	for rule: SpawnRule in spawn_rules:
		rules[rule.spawn_id] = rule
		alive_by_spawn[rule.spawn_id] = []

func spawn_initial_monsters():
	for rule in rules.values():
		for index in range(rule.max_alive):
			_spawn_monster(rule)

func get_alive_count(spawn_id: String) -> int:
	_prune_invalid_monsters(spawn_id)
	return alive_by_spawn.get(spawn_id, []).size()

func _spawn_monster(rule: SpawnRule) -> bool:
	if not is_instance_valid(monster_container):
		return false

	if get_alive_count(rule.spawn_id) >= rule.max_alive:
		return false

	var spawn_position = _find_valid_spawn_position(rule)
	if spawn_position == null:
		return false

	var monster: Monster = rule.monster_scene.instantiate()
	monster.position = monster_container.to_local(spawn_position)
	monster.configure(
		rule.monster_id,
		rule.display_name,
		rule.max_hp,
		rule.experience_reward,
		rule.gold_reward
	)
	monster.defeated.connect(
		_on_monster_defeated.bind(rule.spawn_id)
	)

	monster_container.add_child(monster)
	var monster_ai := monster.get_node_or_null("MonsterAI") as MonsterAI
	if monster_ai != null:
		monster_ai.configure(monster.global_position, rule.spawn_area)

	alive_by_spawn[rule.spawn_id].append(monster)
	monster_spawned.emit(monster)
	return true

func _on_monster_defeated(
	monster: Monster,
	monster_id: String,
	display_name: String,
	experience_reward: int,
	gold_reward: int,
	spawn_id: String
):
	var rule: SpawnRule = rules.get(spawn_id)
	if rule == null:
		return

	alive_by_spawn[spawn_id].erase(monster)
	monster_defeated.emit(
		monster,
		spawn_id,
		rule.monster_type,
		monster_id,
		display_name,
		experience_reward,
		gold_reward
	)
	_schedule_respawn(rule)

func _schedule_respawn(rule: SpawnRule):
	await get_tree().create_timer(rule.respawn_seconds).timeout

	if get_alive_count(rule.spawn_id) < rule.max_alive:
		if not _spawn_monster(rule):
			_schedule_respawn(rule)

func _find_valid_spawn_position(rule: SpawnRule):
	for attempt in range(rule.max_spawn_attempts):
		var candidate := _get_random_position_in_area(rule.spawn_area)
		if _is_spawn_position_valid(candidate, rule.min_distance_to_entities):
			return candidate

	return null

func _get_random_position_in_area(area: Rect2) -> Vector2:
	return Vector2(
		random.randf_range(area.position.x, area.end.x),
		random.randf_range(area.position.y, area.end.y)
	)

func _is_spawn_position_valid(
	candidate: Vector2,
	min_distance_to_entities: float
) -> bool:
	for blocker in get_tree().get_nodes_in_group("spawn_blockers"):
		if not blocker is Node2D:
			continue
		if not is_instance_valid(blocker) or blocker.is_queued_for_deletion():
			continue
		if candidate.distance_to(blocker.global_position) < min_distance_to_entities:
			return false

	return true

func _prune_invalid_monsters(spawn_id: String):
	if not alive_by_spawn.has(spawn_id):
		return

	var alive_monsters: Array = alive_by_spawn[spawn_id]
	for index in range(alive_monsters.size() - 1, -1, -1):
		if not is_instance_valid(alive_monsters[index]):
			alive_monsters.remove_at(index)
