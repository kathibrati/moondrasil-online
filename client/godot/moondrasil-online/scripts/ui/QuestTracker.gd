extends CanvasLayer

@onready var active_quest_list = $Interface/Panel/Content/ActiveQuestList
@onready var completed_quest_list = $Interface/Panel/Content/CompletedQuestList

func _ready():
	$Interface/Panel.visible = false

func add_active_quest(quest_state: QuestState):
	var quest = quest_state.quest
	var quest_entry = VBoxContainer.new()
	quest_entry.name = quest.id

	var title_label = Label.new()
	title_label.text = quest.title
	quest_entry.add_child(title_label)

	var objective_label = Label.new()
	objective_label.name = "Objective"
	objective_label.text = "- " + quest_state.get_objective_text()
	objective_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	quest_entry.add_child(objective_label)

	var status_label = Label.new()
	status_label.name = "Status"
	status_label.visible = false
	quest_entry.add_child(status_label)

	active_quest_list.add_child(quest_entry)
	quest_state.progress_changed.connect(
		_update_quest.bind(quest_state)
	)
	$Interface/Panel.visible = true

func _update_quest(quest_state: QuestState):
	var quest_entry = active_quest_list.get_node_or_null(quest_state.quest.id)
	if not quest_entry:
		return

	var objective_label = quest_entry.get_node("Objective")
	var status_label = quest_entry.get_node("Status")
	objective_label.text = "- " + quest_state.get_objective_text()
	status_label.text = "Ready to turn in"
	status_label.visible = quest_state.is_ready_to_turn_in()

func complete_quest(quest_state: QuestState):
	var quest = quest_state.quest
	var active_entry = active_quest_list.get_node_or_null(quest.id)

	if active_entry:
		active_entry.queue_free()

	var completed_label = Label.new()
	completed_label.name = quest.id
	completed_label.text = quest.title
	completed_quest_list.add_child(completed_label)
