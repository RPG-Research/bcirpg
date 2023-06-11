extends Panel

onready var drop_target = get_node("/root/Tabbed_merged_test/VLayout/HBoxContainer/TabContainer/Structural_Tab/PanelCanvas_Temp")

onready var draggable_assets_scene: PackedScene = preload("res://toolset_test_tabbed_merged/draggable_assets.tscn")
onready var draggable_assets_container = $Padding/AssetsRows

var dragables = [
	{"id": 1, "label": "region", "color": "red"},
	{"id": 2, "label": "location", "color": "orange"},
	{"id": 3, "label": "space", "color": "yellow"},
	{"id": 4, "label": "scene", "color": "green"},	
]


func _ready() -> void:
	drop_target.connect("item_dropped_on_target", self, "_on_item_dropped_on_target")
	_populate_dragables()

func _populate_dragables():
	for dragable in dragables:
		var drag_item = draggable_assets_scene.instance()
		drag_item.id = dragable["id"]
		drag_item.label = dragable["label"]
		drag_item.color = _set_color_from_text(dragable["color"])
		draggable_assets_container.add_child(drag_item)

func _on_item_dropped_on_target(dropped_item: Draggable_Assets) -> void:
	for drag_item in draggable_assets_container.get_children():
		drag_item = (drag_item as Draggable_Assets)
		if drag_item.id == dropped_item.id:
			#draggable_container.remove_child(drag_item)
			#drag_item.queue_free()
			break

#DKM TEMP: for refactoring, this should live elsewhere, but as we get this up. 
func _set_color_from_text(colorTerm: String) -> Color:
	var end_color = Color8(0,0,0)
	match(colorTerm):
		"red":
			end_color = Color8(255,0,0)
		"orange":
			end_color = Color8(255,102,0)
		"yellow":
			end_color = Color8(255,255,0)
		"green":
			end_color = Color8(0,102,0)
		"blue":
			end_color = Color8(0,0,255)									
	return end_color
