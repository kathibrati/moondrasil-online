extends CanvasLayer

@onready var hint_label = $Interface/HintLabel
@onready var dialog_panel = $Interface/DialogPanel
@onready var npc_name_label = $Interface/DialogPanel/Content/NpcName
@onready var dialog_text_label = $Interface/DialogPanel/Content/DialogText

func _ready():
	hide_hint()
	close_dialog()

func show_hint(text: String = "Press E to talk"):
	hint_label.text = text
	hint_label.visible = true

func hide_hint():
	hint_label.visible = false

func open_dialog(npc_name: String, dialog_text: String):
	npc_name_label.text = npc_name
	dialog_text_label.text = dialog_text
	dialog_panel.visible = true
	hide_hint()

func close_dialog():
	dialog_panel.visible = false

func is_dialog_open() -> bool:
	return dialog_panel.visible
