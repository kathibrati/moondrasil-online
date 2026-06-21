class_name PlayerState
extends Resource

signal stats_changed
signal inventory_changed

var character_id: String = ""
var character_name: String = "Unknown"
var experience: int = 0
var gold: int = 0
var inventory: Array[ItemData] = []
var attack_interval_seconds: float = 1.2
var last_attack_time_seconds: float = -INF

func can_attack(current_time_seconds: float) -> bool:
	return (
		current_time_seconds - last_attack_time_seconds
		>= attack_interval_seconds
	)

func record_attack(current_time_seconds: float):
	last_attack_time_seconds = current_time_seconds

func add_experience(amount: int):
	experience += amount
	stats_changed.emit()

func add_gold(amount: int):
	gold += amount
	stats_changed.emit()

func grant_combat_rewards(experience_reward: int, gold_reward: int):
	experience += experience_reward
	gold += gold_reward
	stats_changed.emit()

func add_item(item: ItemData):
	inventory.append(item)
	inventory_changed.emit()

func grant_quest_rewards(quest: QuestData):
	experience += quest.reward_experience
	gold += quest.reward_gold

	for item in quest.reward_items:
		inventory.append(item)

	stats_changed.emit()
	inventory_changed.emit()
