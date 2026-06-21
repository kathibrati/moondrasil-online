class_name CombatController
extends Node

signal monster_defeated(monster_id: String)

var targeting: TargetingController
var player_state: PlayerState
var auto_attack_enabled := false

func configure(targeting_controller: TargetingController, state: PlayerState):
	targeting = targeting_controller
	player_state = state
	targeting.target_changed.connect(_on_target_changed)

func _process(_delta: float):
	if auto_attack_enabled:
		attack_selected()

func attack_selected():
	var target := targeting.selected_target
	if not is_instance_valid(target):
		targeting.clear_target()
		return
	if not target.can_be_attacked():
		targeting.show_status(
			"Target: %s | Cannot attack" % target.get_target_name()
		)
		return

	var now := _get_combat_time_seconds()
	if not player_state.can_attack(now):
		return

	var monster := target as Monster
	player_state.record_attack(now)
	monster.take_damage(1)
	if is_instance_valid(monster) and not monster.is_defeated:
		targeting.show_status("Target: %s | HP: %d / %d" % [
			monster.monster_name,
			monster.current_hp,
			monster.max_hp
		])

func start_auto_attack(world_position: Vector2):
	targeting.select_at(world_position)
	var target := targeting.selected_target
	if not is_instance_valid(target):
		stop_auto_attack()
		return

	if not target.can_be_attacked():
		stop_auto_attack()
		targeting.show_status(
			"Target: %s | Cannot attack" % target.get_target_name()
		)
		return

	auto_attack_enabled = true
	attack_selected()

func stop_auto_attack():
	auto_attack_enabled = false

func handle_monster_defeated(
	monster: Monster,
	_spawn_id: String,
	_monster_type: String,
	monster_id: String,
	_monster_name: String,
	experience_reward: int,
	gold_reward: int
):
	targeting.clear_target(monster)
	stop_auto_attack()
	player_state.grant_combat_rewards(experience_reward, gold_reward)
	targeting.show_status("Target defeated")
	monster_defeated.emit(monster_id)

func _on_target_changed(target: Node2D):
	if not is_instance_valid(target) or not target.can_be_attacked():
		stop_auto_attack()

func _get_combat_time_seconds() -> float:
	return Time.get_ticks_msec() / 1000.0
