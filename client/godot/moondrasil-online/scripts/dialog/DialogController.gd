class_name DialogController
extends Node

var dialog_box: CanvasLayer
var quest_manager: QuestManager
var active_npc: Node2D

func configure(box: CanvasLayer, quests: QuestManager):
	dialog_box = box
	quest_manager = quests
	dialog_box.action_pressed.connect(_on_dialog_action_pressed)

func register_npc(npc: Node2D):
	npc.interaction_available.connect(_on_interaction_available)
	npc.interaction_unavailable.connect(_on_interaction_unavailable)

func interact():
	if not is_instance_valid(active_npc):
		return
	if dialog_box.is_dialog_open():
		close_dialog()
	else:
		_open_dialog()

func cancel():
	if dialog_box.is_dialog_open():
		close_dialog()

func close_dialog():
	dialog_box.close_dialog()
	if is_instance_valid(active_npc):
		dialog_box.show_hint("Press %s to talk" % _get_action_text("interact"))

func _open_dialog():
	var quest: QuestData = active_npc.quest_offer
	var text: String = active_npc.offer_dialog
	var action := ""

	if quest != null:
		if quest_manager.is_completed(quest.id):
			text = active_npc.completed_dialog
		elif quest_manager.get_state(quest.id) != null:
			var state := quest_manager.get_state(quest.id)
			if state.is_ready_to_turn_in():
				text = active_npc.ready_dialog
				action = "Complete"
			else:
				text = "%s\n\n%s" % [
					active_npc.active_dialog,
					state.get_objective_text()
				]
		else:
			action = "Accept"

	dialog_box.open_dialog(active_npc.npc_name, text, action)

func _on_dialog_action_pressed():
	if not is_instance_valid(active_npc) or active_npc.quest_offer == null:
		return

	var quest: QuestData = active_npc.quest_offer
	if quest_manager.get_state(quest.id) != null:
		if quest_manager.complete(quest.id):
			close_dialog()
	else:
		quest_manager.accept(quest)
		close_dialog()

func _on_interaction_available(npc: Node2D):
	active_npc = npc
	dialog_box.show_hint("Press %s to talk" % _get_action_text("interact"))

func _on_interaction_unavailable(npc: Node2D):
	if active_npc != npc:
		return
	active_npc = null
	dialog_box.hide_hint()
	dialog_box.close_dialog()

func _get_action_text(action_name: StringName) -> String:
	var events := InputMap.action_get_events(action_name)
	return str(action_name) if events.is_empty() else events[0].as_text()
