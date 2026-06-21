class_name QuestState
extends Resource

enum Status {
	AVAILABLE,
	ACTIVE,
	READY_TO_TURN_IN,
	COMPLETED
}

signal progress_changed

var quest: QuestData
var status: int = Status.AVAILABLE
var objective_progress: int = 0

static func create(quest_data: QuestData) -> QuestState:
	var quest_state = QuestState.new()
	quest_state.quest = quest_data
	return quest_state

func record_monster_defeated(monster_id: String) -> bool:
	if status != Status.ACTIVE:
		return false

	if quest.objective_type != QuestData.ObjectiveType.DEFEAT_MONSTER:
		return false

	if quest.objective_target_id != monster_id:
		return false

	objective_progress = min(
		objective_progress + 1,
		quest.objective_required_count
	)

	if objective_progress >= quest.objective_required_count:
		status = Status.READY_TO_TURN_IN

	progress_changed.emit()
	return true

func is_ready_to_turn_in() -> bool:
	return status == Status.READY_TO_TURN_IN

func get_objective_text() -> String:
	if quest.objective_type == QuestData.ObjectiveType.DEFEAT_MONSTER:
		return "Defeat %s %d/%d" % [
			quest.objective_target_name,
			objective_progress,
			quest.objective_required_count
		]

	return quest.objective
