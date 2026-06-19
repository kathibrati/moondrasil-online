class_name QuestData
extends Resource

var id: String = ""
var title: String = ""
var description: String = ""
var objective: String = ""
var reward_experience: int = 0
var reward_gold: int = 0
var reward_items: Array[ItemData] = []

static func create(
	quest_id: String,
	quest_title: String,
	quest_description: String,
	quest_objective: String
) -> QuestData:
	var quest = QuestData.new()
	quest.id = quest_id
	quest.title = quest_title
	quest.description = quest_description
	quest.objective = quest_objective
	return quest
