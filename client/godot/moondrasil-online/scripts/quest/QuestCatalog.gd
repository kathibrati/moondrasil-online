class_name QuestCatalog
extends RefCounted

static func create_welcome_quest() -> QuestData:
	var quest := QuestData.create(
		"welcome_to_moondrasil",
		"Welcome to Moondrasil",
		"Learn the basics of movement, targeting, and combat.",
		"Defeat Moon Slime"
	)
	quest.set_defeat_monster_objective("moon_slime", "Moon Slime", 1)
	quest.reward_experience = 100
	quest.reward_gold = 10
	quest.reward_items.append(
		ItemData.create("wooden_sword", "Wooden Sword")
	)
	return quest
