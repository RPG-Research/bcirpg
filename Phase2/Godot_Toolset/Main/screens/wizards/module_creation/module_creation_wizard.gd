extends Control


export var region_container_path: NodePath
onready var region_container = get_node(region_container_path)

export var file_dialog_path: NodePath
onready var file_dialog = get_node(file_dialog_path)

export var region_object_scene: PackedScene

export var space_display_height: int
export var space_display_height_margin: int
export var space_display_width: int
export var space_display_width_margin: int

var nodes_with_text = ["Name", "Description", "Id", "Start", "Action", "A_Params", "Text", "Option_Labels", "Option_GoTos"]
var nodes_with_multiples = ["Region", "Location", "Space"]

var module_dict

var region_object_array = []
var space_dict = {}
var space_start
var space_dict_displayed = [] # array of already-displayed spaces to prevent looping
var connection_dict = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if space_start != null:
		_update_tree_connections()
	


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
	
	if file_dialog.get_mode() == FileDialog.MODE_OPEN_FILE:
		var xml_parser = XMLParser.new()
		xml_parser.open(path)
		
		while xml_parser.read() != ERR_FILE_EOF:
			var node_type = xml_parser.get_node_type()
			var node_name
			var node_dict_type # NOT the same as the xml parser's node type
			if node_type != XMLParser.NODE_TEXT:
				node_name = xml_parser.get_node_name()
				node_dict_type = node_name.rstrip("0123456789_")
			
			# we expect a NODE_UNKNOWN at the top, followed by a series of NODE_ELEMENT, NODE_TEXT, and NODE_ELEMENT_END
			#print(node_type)
			match node_type:
				XMLParser.NODE_ELEMENT:
					# each node element is its own dictionary
					var new_dict = {}
					new_dict["Type"] = node_dict_type
					
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
						elif nodes_with_text.has(node_name):
							# EDIT: we'll store the type of node and the text of the node
							node_stack[-1][node_name] = new_dict
							node_stack.append(new_dict)
						else: # node is not an array, so if anything already exists at node_name, we'll just replace it; this is a fallback, all known nodes fall into the above types
							node_stack[-1][node_name] = new_dict
							node_stack.append(new_dict)
				XMLParser.NODE_ELEMENT_END:
					#print("popping " + node_name)
					if node_dict_type != node_stack[-1]["Type"]:
						print("Mismatched node ends: " + node_stack[-1]["Type"] + " and " + node_dict_type)
					elif node_name == "root":
						print("We should be done now.")
					else:
						node_stack.pop_back()
						# this might be the place to save something?
				XMLParser.NODE_TEXT:
					# first make sure we're in an element that should have text
					for text_node_label in nodes_with_text:
						if node_stack[-1]["Type"] == text_node_label: # this means we have a valid node for storing text
							var node_text = xml_parser.get_node_data()
							node_stack[-1]["Text"] = node_text
							break
	module_dict = node_stack[0]
	display_module_dict()

func display_module_dict():
	_construct_display_tree(module_dict, false, null)
	space_dict_displayed.append(space_start)
	_display_tree(space_start, Vector2(0,0))
	#print(space_dict)
	#print(space_start)
	_display_tree_connections(space_start)

func _update_tree_connections():
	for i in connection_dict.keys():
		for j in connection_dict[i].keys():
			connection_dict[i][j].set_point_position(0, Vector2(space_dict[i]["RegionObject"].rect_size.x,0))
			connection_dict[i][j].set_point_position(1, space_dict[j]["RegionObject"].rect_position - space_dict[i]["RegionObject"].rect_position)

func _display_tree_connections(current_branch_id):
	# go through each branch, drawing lines from each connection to it's child
	var space_object = space_dict[current_branch_id]["RegionObject"]
	
	if !connection_dict.has(current_branch_id):
		connection_dict[current_branch_id] = {}
		for id in space_dict[current_branch_id]["Gotos"]:
			#draw a line from the current object to the new one, then do the same for the new object
			var new_line = Line2D.new()
			space_object.add_child(new_line)
			new_line.add_point(space_object.rect_position+Vector2(space_object.rect_size.x,0))
			var new_space_object = space_dict[id]["RegionObject"]
			new_line.add_point(new_space_object.rect_position)
			connection_dict[current_branch_id][id] = new_line
			_display_tree_connections(id)

func _display_tree(current_branch_id, current_location):
	# we want to show space_dict as a branching tree, starting with space_start
	print("displaying ", current_branch_id)
	
	var new_display_object = region_object_scene.instance()
	region_container.add_child(new_display_object)
	
	space_dict[current_branch_id]["RegionObject"] = new_display_object # might as well make the object easier to access later
	
	var space_object = space_dict[current_branch_id]["Object"]
	
	for key in space_object:
		if nodes_with_text.has(key.rstrip("1234567890_")) && space_object[key].has("Text"):
			var new_key_pair = HBoxContainer.new()
			var new_key_text = Label.new()
			var new_text = LineEdit.new()
			new_key_pair.add_child(new_key_text)
			new_key_pair.add_child(new_text)
			
			new_text.size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_FILL
			new_text.size_flags_vertical = Control.SIZE_EXPAND | Control.SIZE_FILL
			new_key_text.text = key
			new_text.text =  space_object[key]["Text"]
				
			new_display_object.add_to_region_box(new_key_pair)
			new_display_object.rect_position = current_location
			new_display_object.rect_size = Vector2(space_display_width, space_display_height)
			
	var to_display = []
	for id in space_dict[current_branch_id]["Gotos"]: # determine the branches left to display
		if !space_dict_displayed.has(id):
			to_display.append(id)
		else:
			print(id, " already displayed")
	print("num gotos: ", to_display.size())
	
	var branch_display_height = to_display.size() * space_display_height + (to_display.size() - 1) * space_display_height_margin
	var branch_display_location = Vector2(current_location.x + space_display_width + space_display_width_margin, current_location.y + (space_display_height/2.0) - (branch_display_height/2.0))
	for id in to_display:
		space_dict_displayed.append(id)
		_display_tree(id, branch_display_location)
		branch_display_location += Vector2(0, space_display_height + space_display_height_margin)

func _construct_display_tree(search_object, inside_space, space_id):
	# we want to only display options for now and what they link to
	# we'll traverse the module dict, i guess?
	#var new_holder_object = holder_object # we change the holder object if we find a space to store children in
	
	if inside_space && nodes_with_text.has(search_object["Type"]) && search_object.has("Text"): # region object means we're in a Space, also text can be empty
		if search_object["Type"] == "Option_GoTos":
			if !space_dict[space_id].has("Gotos"):
				space_dict[space_id]["Gotos"] = []
			space_dict[space_id]["Gotos"].append(search_object["Text"])
		elif search_object["Type"] == "Start" && search_object["Text"] == "True":
			space_start = space_id
	elif search_object is Dictionary && search_object["Type"] == "Space": # this means we have a space
		inside_space = true

	if search_object is Dictionary || search_object is Array:
		#print("looping")
		for key in search_object:
			var item
			if search_object is Dictionary: # if the object is a dictionary, then we need to search by key
				if search_object["Type"] == "Space": # add space to the space dict so we can map connections
					space_id = search_object["Id"]["Text"]
					if !space_dict.has(space_id):
						space_dict[space_id] = {}
						space_dict[space_id]["Object"] = search_object
					
				item = search_object[key]
			elif search_object is Array:
				# print("searching array")
				item = key
			else:
				print("unexpected search object type: ", typeof(search_object))
				# can't quite figure out how to access the enum to just convert this to the key text, but you can just compare to Variant.Types in GlobalScope
			
			if !(item is String): # type is just for checking what sort of object we're in, and it doesn't need to be traversed
				_construct_display_tree(item, inside_space, space_id)
	else:
		print("unsearchable object: ", typeof(search_object), " " + search_object)

func highlight_options(destination_text):
	for region_object in region_object_array:
		region_object.highlight_destination(destination_text)
