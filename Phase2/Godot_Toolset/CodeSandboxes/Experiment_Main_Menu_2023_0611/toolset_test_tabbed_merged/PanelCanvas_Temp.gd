extends Panel


signal item_dropped_on_target(draggable_assets)
var draggable_assets: PackedScene = preload("res://toolset_test_tabbed_merged/draggable_assets.tscn")

func can_drop_data(position: Vector2, data) -> bool:
	var can_drop: bool = data is Node and data.is_in_group("DRAGGABLE_ASSETS")
	print("[TargetContainer] can_drop_data has run, returning %s" % can_drop)
	return can_drop

func drop_data(position: Vector2, data) -> void:
	print("[TargetContainer] drop_data has run")
	print("[TargetContainer] Emiting signal: item_dropped_on_target")

	#DKM TEMP: here we'd open wizard or create new item.
	#	How should this display when it's finalized?  
	var draggable_copy: ColorRect = draggable_assets.instance()
	draggable_copy.id = data.id
	#Instantiate a new version of the specific item in this content capsule
	draggable_copy.label = data.label
	draggable_copy.dropped_on_target = true # disable further dragging
	$Padding/Rows.add_child(draggable_copy)

	emit_signal("item_dropped_on_target", data)
