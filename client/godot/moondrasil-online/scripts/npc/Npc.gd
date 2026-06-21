extends Node2D

signal interaction_available(npc)
signal interaction_unavailable(npc)

@export var npc_name: String = "NPC"
@export_multiline var offer_dialog: String = ""
@export_multiline var active_dialog: String = ""
@export_multiline var ready_dialog: String = ""
@export_multiline var completed_dialog: String = ""
var quest_offer: QuestData = null

func _ready():
	add_to_group("targetables")
	add_to_group("npcs")
	add_to_group("spawn_blockers")
	set_npc_name(npc_name)
	$InteractionArea.body_entered.connect(_on_interaction_area_body_entered)
	$InteractionArea.body_exited.connect(_on_interaction_area_body_exited)

func set_npc_name(name: String):
	npc_name = name
	$Nameplate/NpcName.text = npc_name

func set_quest_offer(quest: QuestData):
	quest_offer = quest

func configure(definition: Dictionary):
	position = definition.get("position", Vector2.ZERO)
	set_npc_name(str(definition.get("display_name", "NPC")))
	quest_offer = definition.get("quest")
	offer_dialog = str(definition.get("offer_dialog", ""))
	active_dialog = str(definition.get("active_dialog", offer_dialog))
	ready_dialog = str(definition.get("ready_dialog", active_dialog))
	completed_dialog = str(definition.get("completed_dialog", ready_dialog))

func _on_interaction_area_body_entered(body: Node2D):
	if body.is_in_group("player"):
		interaction_available.emit(self)

func _on_interaction_area_body_exited(body: Node2D):
	if body.is_in_group("player"):
		interaction_unavailable.emit(self)

func set_targeted(is_targeted: bool):
	$TargetIndicator.visible = is_targeted

func get_target_name() -> String:
	return npc_name

func can_be_attacked() -> bool:
	return false
