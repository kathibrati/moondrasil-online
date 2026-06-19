extends CanvasLayer

@onready var character_name_label = $Interface/Panel/Content/CharacterName
@onready var gold_label = $Interface/Panel/Content/Gold
@onready var experience_label = $Interface/Panel/Content/Experience

var player_state: PlayerState

func bind(state: PlayerState):
	player_state = state
	player_state.stats_changed.connect(_refresh)
	_refresh()

func _refresh():
	character_name_label.text = "Character: " + player_state.character_name
	gold_label.text = "Gold: %d" % player_state.gold
	experience_label.text = "EXP: %d" % player_state.experience
