extends Control


export var region_grid_path: NodePath
onready var region_grid = get_node(region_grid_path)

export var file_dialog_path: NodePath
onready var file_dialog = get_node(file_dialog_path)

export var region_object_scene: PackedScene

var nodes_with_text = ["Name", "Description", "Id", "Start", "Action", "A_Params", "Text", "Option_Labels_", "Option_GoTos_"]
var nodes_with_multiples = ["Region", "Location", "Space"]

var module_dict

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ButtonLoad_pressed():
	file_dialog.set_mode(FileDialog.MODE_OPEN_FILE)
	file_dialog.popup_centered()


func _on_ButtonSave_pressed():
	pass # Replace with function body.


func _on_ButtonNew_pressed():
	pass # Replace with function body.
	

func _on_FileDialog_file_selected(path):
	print("file dialog selected")
	var node_stack = [] #keeps our data
	var node_name_stack = [] #keeps track of where we are
	
	if file_dialog.get_mode() == FileDialog.MODE_OPEN_FILE:
		var xml_parser = XMLParser.new()
		xml_parser.open(path)
		
		while xml_parser.read() != ERR_FILE_EOF:
			var node_name
			var node_type = xml_parser.get_node_type()
			
			# we expect a NODE_UNKNOWN at the top, followed by a series of NODE_ELEMENT, NODE_TEXT, and NODE_ELEMENT_END
			#print(node_type)
			match node_type:
				XMLParser.NODE_ELEMENT:
					node_name = xml_parser.get_node_name()
					# each node element is its own dictionary
					var new_dict = {}
					
					# each element is added to the name stack so we know what element(s) we're inside
					node_name_stack.append(node_name)
					
					# a properly-formatted xml has only one root, and we have one dictionary to hold all the smaller dictionaries
					if node_name == "root":
						node_stack.append(new_dict) # note that adding a dict to the stack for editing later works because Godot stores dictionaries by reference
					else:
						# first, we'll check if this is a node type that should be in an array
						if nodes_with_multiples.has(node_name): # node is an array type
							# check if an array for this node type already exists in the parent
							# print(node_name)
							if node_stack[-1].has(node_name):
								#if it exists, we can just add to it
								node_stack[-1][node_name].append(new_dict)
								node_stack.append(new_dict)
							else: # if an array for this node type does not exist, we'll have to make one
								node_stack[-1][node_name] = [new_dict]
								node_stack.append(new_dict)
						elif nodes_with_text.has(node_name): # node should be text, not a new dict
							# this is the one place we won't add new_dict, since we want to access a string inside it instead
							pass
						else: # node is not an array, so if anything already exists at node_name, we'll just replace it; this is a fallback, all known nodes fall into the above types
							node_stack[-1][node_name] = new_dict
							node_stack.append(new_dict)
				XMLParser.NODE_ELEMENT_END:
					node_name = xml_parser.get_node_name()
					#print("popping " + node_name)
					if node_name != node_name_stack[-1]:
						print("Mismatched node ends: " + node_name_stack[-1] + " and " + node_name)
					elif node_name == "root":
						print("We should be done now.")
					else:
						node_name_stack.pop_back()
						if !nodes_with_text.has(node_name): # remember, nodes with text don't add a new dictionary to the stack
							node_stack.pop_back()
						# this might be the place to save something?
				XMLParser.NODE_TEXT:
					# first make sure we're in an element that should have text
					var text_to_check = node_name_stack[-1].rstrip("0123456789")
					
					for text_node_label in nodes_with_text:
						if text_to_check  == text_node_label: # this means we have a valid node for storing text
							var node_text = xml_parser.get_node_data()
							node_stack[-1][node_name_stack[-1]] = node_text
							break
	module_dict = node_stack[0]
	display_module_dict()

func display_module_dict():
	#print(module_dict)
	# here we should recursively traverse the module dict and display it, ig
	# each region, location, and space should be its own object
	# each set of regions, location, spaces, labels, and gotos should be stored in its own grid within the aforementioned object
	#      actually maybe labels and gotos should be in a list
	# other variables should be displayed in a non-grid way in the object instead
	_display_module_dict_recursive(module_dict, region_grid, null)
	region_grid.columns = round(sqrt(region_grid.get_child_count()))

func _display_module_dict_recursive(object_to_display, holder_object, key):
	# holder should already be of the correct type
	# create the right structure to display object_to_display
	# put object_to_display in holder object_to_display
	# if object_to_display has children, dtermine the correct holder object and recurse with holder and child
	
	# create the correct object for self and insert it into the given holder object
	var new_holder_object
	
	# end of the line...
	if object_to_display is String:
		var new_key_pair = HBoxContainer.new()
		var new_key_text = Label.new()
		var new_text = LineEdit.new()
		new_key_pair.add_child(new_key_text)
		new_key_pair.add_child(new_text)
		
		new_text.size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_FILL
		new_text.size_flags_vertical = Control.SIZE_EXPAND | Control.SIZE_FILL
		new_key_text.text = key
		new_text.text = object_to_display
		
		if holder_object is RegionObject:
			holder_object.add_to_region_box(new_key_pair)
		else :
			holder_object.add_child(new_key_pair)
		return
	elif object_to_display is Array:
		new_holder_object = GridContainer.new()
		new_holder_object.columns = round(sqrt(object_to_display.size()))
	elif object_to_display is Dictionary:
		new_holder_object = region_object_scene.instance()
		
	new_holder_object.size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_FILL
	new_holder_object.size_flags_vertical = Control.SIZE_EXPAND | Control.SIZE_FILL
	
	# add the object to the holder_object
	if holder_object is RegionObject:
		holder_object.add_to_region_box(new_holder_object)
	else:
		holder_object.add_child(new_holder_object)
	
	# create the correct holder object for each child and call the method recursively to insert them into the new holder object
	for new_key in object_to_display:
		var item
		
		if object_to_display is Dictionary: # if the object is a dictionary, then we need to search by key
			item = object_to_display[new_key]
		else:
			item = new_key
			new_key = null
		
		_display_module_dict_recursive(item, new_holder_object, new_key)
