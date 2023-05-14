extends Panel

onready var drop_target = get_node("/root/Tabbed_merged_test/VLayout/HBoxContainer/TabContainer/Structural_Tab/PanelCanvas_Temp")

onready var draggable_assets_scene: PackedScene = preload("res://toolset_test_tabbed_merged/draggable_assets.tscn")
onready var draggable_assets_container = $Padding/AssetsRows

var dragables = [
	{"id": 1, "label": "region"},
	{"id": 2, "label": "location"},
	{"id": 3, "label": "space"},
	{"id": 4, "label": "scene"},	
]


func _ready() -> void:
	drop_target.connect("item_dropped_on_target", self, "_on_item_dropped_on_target")
	_populate_dragables()

func _populate_dragables():
	for dragable in dragables:
		var drag_item = draggable_assets_scene.instance()
		drag_item.id = dragable["id"]
		drag_item.label = dragable["label"]
		draggable_assets_container.add_child(drag_item)

func _on_item_dropped_on_target(dropped_item: Draggable_Assets) -> void:
	for drag_item in draggable_assets_container.get_children():
		drag_item = (drag_item as Draggable_Assets)
		if drag_item.id == dropped_item.id:
			#draggable_container.remove_child(drag_item)
			#drag_item.queue_free()
			break
