extends CharacterBody2D

const MOVEMENT_SPEED := 200.0

var character_id: String = ""
var character_name: String = "Unknown"

func _ready():
	add_to_group("player")
	add_to_group("players")
	add_to_group("spawn_blockers")
	set_character_name(character_name)

func set_character_name(name: String):
	character_name = name
	$Nameplate/CharacterName.text = character_name

func _physics_process(_delta):
	var direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)
	velocity = direction * MOVEMENT_SPEED
	move_and_slide()
