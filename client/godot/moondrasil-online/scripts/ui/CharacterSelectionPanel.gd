class_name CharacterSelectionPanel
extends PanelContainer

signal character_selected(character_id: String)

@onready var character_list: VBoxContainer = $Content/CharacterList
@onready var empty_label: Label = $Content/EmptyLabel

func _ready():
	hide()

func show_characters(characters: Array):
	_clear_characters()

	for character in characters:
		if typeof(character) != TYPE_DICTIONARY:
			continue

		var character_id := str(character.get("id", ""))
		var character_name := str(character.get("name", "Unknown"))
		if character_id.is_empty():
			continue

		var button := Button.new()
		button.text = character_name
		button.tooltip_text = "Enter world as %s" % character_name
		button.pressed.connect(
			_on_character_pressed.bind(character_id)
		)
		character_list.add_child(button)

	empty_label.visible = character_list.get_child_count() == 0
	show()

func set_selection_enabled(enabled: bool):
	for child in character_list.get_children():
		if child is Button:
			child.disabled = not enabled

func _clear_characters():
	for child in character_list.get_children():
		child.free()

func _on_character_pressed(character_id: String):
	set_selection_enabled(false)
	character_selected.emit(character_id)
