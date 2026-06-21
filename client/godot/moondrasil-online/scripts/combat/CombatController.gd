class_name CombatController
extends Node

signal monster_defeated(monster_id: String)

@export var auto_attack_interval := 0.75

var targeting: TargetingController
var player_state: PlayerState
var auto_attack_enabled := false
var auto_attack_cooldown := 0.0

func configure(targeting_controller: TargetingController, state: PlayerState):
	targeting = targeting_controller
	player_state = state
	targeting.target_changed.connect(_on_target_changed)

func _process(delta: float):
	if not auto_attack_enabled:
		return

	auto_attack_cooldown -= delta
	if auto_attack_cooldown <= 0.0:
		auto_attack_cooldown = auto_attack_interval
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

	var monster := target as Monster
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
	auto_attack_enabled = (
		is_instance_valid(target)
		and target.can_be_attacked()
	)
	auto_attack_cooldown = 0.0

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
	auto_attack_enabled = false
	player_state.grant_combat_rewards(experience_reward, gold_reward)
	targeting.show_status("Target defeated")
	monster_defeated.emit(monster_id)

func _on_target_changed(target: Node2D):
	if not is_instance_valid(target) or not target.can_be_attacked():
		auto_attack_enabled = false
