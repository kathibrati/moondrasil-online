class_name TargetingController
extends Node

signal status_changed(message: String)
signal target_changed(target: Node2D)

@export var targeting_radius := 140.0
@export var click_radius := 50.0

var player: Node2D
var selected_target: Node2D

func configure(player_node: Node2D):
	player = player_node

func _process(_delta: float):
	if is_instance_valid(selected_target) and is_instance_valid(player):
		if player.global_position.distance_to(selected_target.global_position) > targeting_radius:
			clear_target()

func select_nearest():
	if not is_instance_valid(player):
		return

	var nearest: Node2D
	var nearest_distance := targeting_radius
	for target in get_tree().get_nodes_in_group("targetables"):
		if not _is_valid_target(target):
			continue
		var distance: float = player.global_position.distance_to(target.global_position)
		if distance <= nearest_distance:
			nearest = target
			nearest_distance = distance

	set_target(nearest)

func select_at(world_position: Vector2):
	if not is_instance_valid(player):
		return

	var nearest: Node2D
	var nearest_distance := click_radius
	for target in get_tree().get_nodes_in_group("targetables"):
		if not _is_valid_target(target):
			continue
		if player.global_position.distance_to(target.global_position) > targeting_radius:
			continue
		var distance: float = world_position.distance_to(target.global_position)
		if distance <= nearest_distance:
			nearest = target
			nearest_distance = distance

	set_target(nearest)

func set_target(target: Node2D):
	if is_instance_valid(selected_target):
		selected_target.set_targeted(false)

	selected_target = target
	if is_instance_valid(selected_target):
		selected_target.set_targeted(true)
		show_status("Target: %s" % selected_target.get_target_name())
	else:
		show_status("No target in range")
	target_changed.emit(selected_target)

func clear_target(target: Node2D = null):
	if target != null and selected_target != target:
		return
	set_target(null)

func show_status(message: String):
	status_changed.emit(message)

func _is_valid_target(target) -> bool:
	return (
		target is Node2D
		and is_instance_valid(target)
		and not target.is_queued_for_deletion()
	)
