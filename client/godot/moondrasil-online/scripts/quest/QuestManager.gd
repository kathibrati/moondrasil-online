class_name QuestManager
extends Node

var player_state: PlayerState
var quest_tracker: CanvasLayer
var active_quests: Dictionary = {}
var completed_quests: Dictionary = {}

func configure(state: PlayerState, tracker: CanvasLayer):
	player_state = state
	quest_tracker = tracker

func accept(quest: QuestData):
	if quest == null or active_quests.has(quest.id) or completed_quests.has(quest.id):
		return

	var quest_state := QuestState.create(quest)
	quest_state.status = QuestState.Status.ACTIVE
	active_quests[quest.id] = quest_state
	quest_tracker.add_active_quest(quest_state)

func complete(quest_id: String) -> bool:
	var quest_state: QuestState = active_quests.get(quest_id)
	if quest_state == null or not quest_state.is_ready_to_turn_in():
		return false

	quest_state.status = QuestState.Status.COMPLETED
	active_quests.erase(quest_id)
	completed_quests[quest_id] = quest_state
	player_state.grant_quest_rewards(quest_state.quest)
	quest_tracker.complete_quest(quest_state)
	return true

func record_monster_defeated(monster_id: String):
	for quest_state: QuestState in active_quests.values():
		quest_state.record_monster_defeated(monster_id)

func get_state(quest_id: String) -> QuestState:
	return active_quests.get(quest_id)

func is_completed(quest_id: String) -> bool:
	return completed_quests.has(quest_id)
