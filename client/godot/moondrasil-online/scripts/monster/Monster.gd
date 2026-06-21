class_name Monster
extends Node2D

signal defeated(
	monster: Monster,
	monster_id: String,
	monster_name: String,
	experience_reward: int,
	gold_reward: int
)

@export var monster_id: String = "monster"
@export var monster_name: String = "Monster"
@export var max_hp: int = 1
@export var experience_reward: int = 0
@export var gold_reward: int = 0

var current_hp: int
var is_defeated := false

func _ready():
	add_to_group("monsters")
	add_to_group("targetables")
	add_to_group("spawn_blockers")
	current_hp = max_hp
	_refresh_display()

func configure(
	id: String,
	display_name: String,
	hit_points: int,
	reward_experience: int,
	reward_gold: int
):
	monster_id = id
	monster_name = display_name
	max_hp = hit_points
	experience_reward = reward_experience
	gold_reward = reward_gold
	current_hp = max_hp
	_refresh_display()

func take_damage(amount: int):
	if is_defeated or amount <= 0:
		return

	current_hp = max(current_hp - amount, 0)
	_refresh_display()

	if current_hp == 0:
		_die()

func set_targeted(is_targeted: bool):
	$TargetIndicator.visible = is_targeted
	$Visuals/Body.modulate = Color(1.25, 1.25, 1.25) if is_targeted else Color.WHITE

func get_target_name() -> String:
	return monster_name

func can_be_attacked() -> bool:
	return true

func _refresh_display():
	if not is_node_ready():
		return

	$Nameplate/MonsterName.text = monster_name
	$Nameplate/Health.text = "HP: %d / %d" % [current_hp, max_hp]

func _die():
	is_defeated = true
	defeated.emit(
		self,
		monster_id,
		monster_name,
		experience_reward,
		gold_reward
	)
	queue_free()
