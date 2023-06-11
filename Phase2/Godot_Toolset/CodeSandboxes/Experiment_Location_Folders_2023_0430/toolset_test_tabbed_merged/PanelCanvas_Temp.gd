extends Panel


signal item_dropped_on_target(draggable_assets)
var draggable_assets: PackedScene = preload("res://toolset_test_tabbed_merged/draggable_assets.tscn")

func can_drop_data(position: Vector2, data) -> bool:
	var can_drop: bool = data is Node and data.is_in_group("DRAGGABLE_ASSETS")
	print("[TargetContainer] can_drop_data has run, returning %s" % can_drop)
	#DKM TEMP:
	if(!can_drop):
		var temp_bool: bool = data is Node 
		print("Is node? %s" % temp_bool)
		temp_bool = data.is_in_group("DRAGGABLE_ASSETS")
		print("Is in group DRAGGABLE_ASSETS? %s" % temp_bool)
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
	draggable_copy.color = data.color
	draggable_copy.dropped_on_target = true # disable further dragging
	
	#DKM TEMP: create directory 
	var directory = Directory.new()
	#DKM TEMP: this is ridiculously unchecked -- need to verify this, etc:
	var directoryPath = "res://_temp_places/%s_userEnteredName" % data.label
	directory.make_dir(directoryPath)
	var file = File.new()
	var configFilePath = directoryPath + "/config.txt"
	file.open(configFilePath, File.WRITE)
	file.store_line("Temp Config File")
	file.close()
	
	#DKM TEMP: Add to the visual display (for now).  Instead of this, we want to
	#	read the directories that are there for our UI.  We can then still use 
	#	something like a ColorRect, but it should come from that. 
	$Rows.add_child(draggable_copy)

	emit_signal("item_dropped_on_target", data)
