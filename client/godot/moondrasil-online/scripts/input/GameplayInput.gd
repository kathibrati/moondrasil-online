class_name GameplayInput
extends Node

signal target_requested
signal attack_requested
signal auto_attack_requested(world_position: Vector2)
signal interact_requested
signal cancel_requested
signal action_detected(message: String)

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_process_input(true)

func _input(event: InputEvent):
	if event.is_echo():
		return

	if event.is_action_pressed("target_next"):
		action_detected.emit("Input detected: target_next")
		target_requested.emit()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("basic_attack"):
		action_detected.emit("Input detected: basic_attack")
		attack_requested.emit()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("auto_attack"):
		var mouse_position := get_viewport().get_mouse_position()
		if event is InputEventMouseButton:
			mouse_position = event.position
		var world_position := get_viewport().get_canvas_transform().affine_inverse() * mouse_position
		action_detected.emit("Input detected: auto_attack")
		auto_attack_requested.emit(world_position)
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("interact"):
		interact_requested.emit()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_cancel"):
		cancel_requested.emit()
		get_viewport().set_input_as_handled()
