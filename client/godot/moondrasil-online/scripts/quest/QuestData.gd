class_name QuestData
extends Resource

enum ObjectiveType {
	NONE,
	DEFEAT_MONSTER
}

var id: String = ""
var title: String = ""
var description: String = ""
var objective: String = ""
var objective_type: int = ObjectiveType.NONE
var objective_target_id: String = ""
var objective_target_name: String = ""
var objective_required_count: int = 0
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

func set_defeat_monster_objective(
	monster_id: String,
	monster_name: String,
	required_count: int
):
	objective_type = ObjectiveType.DEFEAT_MONSTER
	objective_target_id = monster_id
	objective_target_name = monster_name
	objective_required_count = required_count
	objective = "Defeat %s" % monster_name
