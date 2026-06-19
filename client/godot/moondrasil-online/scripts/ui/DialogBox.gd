extends CanvasLayer

signal action_pressed

@onready var hint_label = $Interface/HintLabel
@onready var dialog_panel = $Interface/DialogPanel
@onready var npc_name_label = $Interface/DialogPanel/Content/NpcName
@onready var dialog_text_label = $Interface/DialogPanel/Content/DialogText
@onready var action_button = $Interface/DialogPanel/Content/ActionButton

func _ready():
	action_button.pressed.connect(_on_action_button_pressed)
	hide_hint()
	close_dialog()

func show_hint(text: String = "Press E to talk"):
	hint_label.text = text
	hint_label.visible = true

func hide_hint():
	hint_label.visible = false

func open_dialog(
	npc_name: String,
	dialog_text: String,
	action_label: String = ""
):
	npc_name_label.text = npc_name
	dialog_text_label.text = dialog_text
	action_button.text = action_label
	action_button.visible = not action_label.is_empty()
	dialog_panel.visible = true
	hide_hint()

func close_dialog():
	dialog_panel.visible = false

func is_dialog_open() -> bool:
	return dialog_panel.visible

func _on_action_button_pressed():
	action_pressed.emit()
