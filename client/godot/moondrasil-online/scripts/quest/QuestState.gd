class_name QuestState
extends Resource

enum Status {
	AVAILABLE,
	ACTIVE,
	COMPLETED
}

var quest: QuestData
var status: int = Status.AVAILABLE

static func create(quest_data: QuestData) -> QuestState:
	var quest_state = QuestState.new()
	quest_state.quest = quest_data
	return quest_state
