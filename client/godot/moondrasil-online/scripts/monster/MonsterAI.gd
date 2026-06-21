class_name MonsterAI
extends Node

enum State {
	IDLE,
	WANDER
}

@export var movement_speed := 40.0
@export var wander_radius := 80.0
@export var min_idle_seconds := 1.0
@export var max_idle_seconds := 3.0
@export var destination_tolerance := 2.0
@export var max_destination_attempts := 20

var state := State.IDLE
var home_position := Vector2.ZERO
var allowed_area := Rect2()
var destination := Vector2.ZERO
var idle_time_remaining := 0.0
var is_active := false

var monster: Monster
var random := RandomNumberGenerator.new()

func _ready():
	monster = get_parent() as Monster
	random.randomize()
	set_process(false)

	if is_instance_valid(monster):
		monster.defeated.connect(_on_monster_defeated)

func configure(spawn_position: Vector2, spawn_area: Rect2):
	home_position = spawn_position
	allowed_area = spawn_area
	destination = home_position
	is_active = true
	set_process(true)
	_enter_idle()

func _process(delta: float):
	if not is_active or not is_instance_valid(monster) or monster.is_defeated:
		return

	match state:
		State.IDLE:
			_update_idle(delta)
		State.WANDER:
			_update_wander(delta)

func _update_idle(delta: float):
	idle_time_remaining -= delta
	if idle_time_remaining <= 0.0:
		_enter_wander()

func _update_wander(delta: float):
	var current_position := monster.global_position
	if current_position.distance_to(destination) <= destination_tolerance:
		monster.global_position = destination
		_enter_idle()
		return

	var next_position := current_position.move_toward(
		destination,
		movement_speed * delta
	)
	monster.global_position = _clamp_to_allowed_area(next_position)

func _enter_idle():
	state = State.IDLE
	idle_time_remaining = random.randf_range(
		min_idle_seconds,
		max_idle_seconds
	)

func _enter_wander():
	destination = _choose_destination()
	if destination.is_equal_approx(monster.global_position):
		_enter_idle()
		return
	state = State.WANDER

func _choose_destination() -> Vector2:
	for attempt in range(max_destination_attempts):
		var angle := random.randf_range(0.0, TAU)
		var distance := sqrt(random.randf()) * wander_radius
		var candidate := (
			monster.global_position
			+ Vector2.RIGHT.rotated(angle) * distance
		)

		if not allowed_area.has_point(candidate):
			continue
		if home_position.distance_to(candidate) > wander_radius:
			continue
		return candidate

	return _clamp_to_allowed_area(home_position)

func _clamp_to_allowed_area(position: Vector2) -> Vector2:
	var clamped := Vector2(
		clamp(position.x, allowed_area.position.x, allowed_area.end.x),
		clamp(position.y, allowed_area.position.y, allowed_area.end.y)
	)

	if home_position.distance_to(clamped) > wander_radius:
		clamped = home_position + (
			home_position.direction_to(clamped) * wander_radius
		)

	return clamped

func _on_monster_defeated(
	_monster: Monster,
	_monster_id: String,
	_monster_name: String,
	_experience_reward: int,
	_gold_reward: int
):
	is_active = false
	set_process(false)
