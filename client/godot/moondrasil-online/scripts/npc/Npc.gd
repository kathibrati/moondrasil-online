extends Node2D

signal interaction_available(npc)
signal interaction_unavailable(npc)

@export var npc_name: String = "NPC"
@export_multiline var interaction_text: String = ""

func _ready():
	set_npc_name(npc_name)
	$InteractionArea.body_entered.connect(_on_interaction_area_body_entered)
	$InteractionArea.body_exited.connect(_on_interaction_area_body_exited)

func set_npc_name(name: String):
	npc_name = name
	$Nameplate/NpcName.text = npc_name

func set_interaction_text(text: String):
	interaction_text = text

func _on_interaction_area_body_entered(body: Node2D):
	if body.is_in_group("player"):
		interaction_available.emit(self)

func _on_interaction_area_body_exited(body: Node2D):
	if body.is_in_group("player"):
		interaction_unavailable.emit(self)
