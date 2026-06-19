class_name ItemData
extends Resource

var id: String = ""
var display_name: String = ""

static func create(item_id: String, item_name: String) -> ItemData:
	var item = ItemData.new()
	item.id = item_id
	item.display_name = item_name
	return item
