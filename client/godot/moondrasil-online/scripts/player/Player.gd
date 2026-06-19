extends CharacterBody2D

const MOVEMENT_SPEED := 200.0

var character_id: String = ""
var character_name: String = "Unknown"

func _ready():
	add_to_group("player")
	set_character_name(character_name)

func set_character_name(name: String):
	character_name = name
	$Nameplate/CharacterName.text = character_name

func _physics_process(_delta):
	var direction := Vector2.ZERO

	if Input.is_key_pressed(KEY_W):
		direction.y -= 1.0
	if Input.is_key_pressed(KEY_S):
		direction.y += 1.0
	if Input.is_key_pressed(KEY_A):
		direction.x -= 1.0
	if Input.is_key_pressed(KEY_D):
		direction.x += 1.0

	velocity = direction.normalized() * MOVEMENT_SPEED
	move_and_slide()
