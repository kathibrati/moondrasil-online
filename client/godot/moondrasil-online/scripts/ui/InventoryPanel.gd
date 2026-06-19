extends CanvasLayer

@onready var item_list = $Interface/Panel/Content/ItemList

var player_state: PlayerState

func bind(state: PlayerState):
	player_state = state
	player_state.inventory_changed.connect(_refresh)
	_refresh()

func _refresh():
	for child in item_list.get_children():
		child.queue_free()

	for item in player_state.inventory:
		var item_label = Label.new()
		item_label.text = item.display_name
		item_list.add_child(item_label)
