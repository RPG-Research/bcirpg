extends Control


export var region_container_path: NodePath
onready var region_container = get_node(region_container_path)

export var file_dialog_path: NodePath
onready var file_dialog = get_node(file_dialog_path)

export var region_tree_path: NodePath
onready var region_tree = get_node(region_tree_path)

export var space_object_scene: PackedScene

export var space_display_height: int
export var space_display_height_margin: int
export var space_display_width: int
export var space_display_width_margin: int

var nodes_with_text = ["Name", "Description", "Id", "Start", "Action", "A_Params", "Text", "Option_Labels", "Option_GoTos"]
var nodes_with_multiples = ["Region", "Location", "Space"]

var module_dict # massive tree created from the loaded xml file
# usage:
# nodes_with_multiples above are stored in arrays since they don't have unique IDs and can't be keyed for a dictionary
# these arrays will be stored in the dict keyed by their type
# ex) module_dict["Region"] should give you an array of top-level regions
# each of these arrays contain dictionaries for each nodes_with_multiples object inside
# each of these dictionaries contain dictionaries for each of their fields
# ex)
# module_dict["Region"]["Type"] returns "Region"
# module_dict["Region"]["Name"] returns a dictionary
# module_dict["Region"]["Name"]["Type"] returns "Name"
# module_dict["Region"]["Name"]["Text"] returns the name of the region as a string
# module_dict["Region"]["Location"] returns an array of location dictionaries
# 
# as you can see, "Type" is usually identical to the key of the dictionary, but there is an exception
# underscores and numbers are stripped from the end of types, so Option_Labels_001 will have the type "Option_Labels"


var space_dict = {} # dictionary of spaces keyed by space ids with links to connected spaces and path to space in the module dict
# usage:
# space_dict[id]["Path"] gives you an array of keys that leads to the space in the module dict
# space_dict[id]["SpaceObject"] gives you the displayed object for the space
# space_dict[id]["Gotos"] gives you an array of space ids that the space connects to

var space_start # space node labeled as the player start
# usage:
# space_start is the id of the starting space, can be used to get the player start from the space_dict

var space_dict_displayed = [] # array of already-displayed spaces to prevent looping
# usage:
# shows the spaces that already have a space_object.tscn instance created for them
# this lets me create only one space object per space and not crash the program by infinitely looping through spaces

var connection_dict = {} # array of connection lines between spaces
# usage:
# mostly used to update connection lines that have physically moved when a space moves


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

# this function puts all the spaces on screen, along with a tree of the various location types
func display_module_dict():
	_construct_space_dict(module_dict, false, null, [])
	space_dict_displayed.append(space_start)
	_display_space_dict(space_start, Vector2(0,0))
	_display_space_dict_connections(space_start)
	_display_regions_locations_tree()

# updates the locations of lines between spaces that link to each other so they move when a space is dragged
func _update_tree_connections():
	for i in connection_dict.keys():
		for j in connection_dict[i].keys():
			connection_dict[i][j].set_point_position(0, Vector2(space_dict[i]["SpaceObject"].rect_size.x,0))
			connection_dict[i][j].set_point_position(1, space_dict[j]["SpaceObject"].rect_position - space_dict[i]["SpaceObject"].rect_position)

# creates lines between spaces that are connected to each other; not very pretty at the moment
func _display_space_dict_connections(current_branch_id):
	# go through each branch, drawing lines from each connection to its child
	var space_object = space_dict[current_branch_id]["SpaceObject"]
	
	if !connection_dict.has(current_branch_id):
		connection_dict[current_branch_id] = {}
		for id in space_dict[current_branch_id]["Gotos"]:
			#draw a line from the current object to the new one, then do the same for the new object
			var new_line = Line2D.new()
			space_object.add_child(new_line)
			new_line.add_point(space_object.rect_position+Vector2(space_object.rect_size.x,0))
			var new_space_object = space_dict[id]["SpaceObject"]
			new_line.add_point(new_space_object.rect_position)
			connection_dict[current_branch_id][id] = new_line
			_display_space_dict_connections(id)

# takes the spaces stored in the space dict (which is derived from the module dict) and creates objects to show them
# starts with the starting space and creates them left to right, where all undisplayed connections to the current space are vertically stacked
func _display_space_dict(current_branch_id, current_location):
# we want to show space_dict as a branching tree, starting with space_start
	print("displaying ", current_branch_id)
	
	var new_display_object = space_object_scene.instance()
	region_container.add_child(new_display_object)
	
	space_dict[current_branch_id]["SpaceObject"] = new_display_object # might as well make the object easier to access later
	
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
				
			new_display_object.add_to_space_box(new_key_pair)
			new_display_object.rect_position = current_location
			new_display_object.rect_size = Vector2(space_display_width, space_display_height)
			
			# we want any edited text box to send out a signal
			new_text.connect("text_changed", self, "_on_space_text_changed", [current_branch_id, key])
			
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
		_display_space_dict(id, branch_display_location)
		branch_display_location += Vector2(0, space_display_height + space_display_height_margin)
		
# recieves a text_changed signal from a LineEdit and updates data structures that need to be updated
# WIP
func _on_space_text_changed(text, branch, key):
	# here we need to determine what changes need to be made where for functionality
	print(key)
	
	var text_type = key.rstrip(0123456789_)
	match text_type:
		"Id":
			pass
			# module_dict, space_dict (id and path), (maybe) space_start, space_dict_displayed, connection_dict
		"Start":
			pass
			# module_dict, space_start
		"Action":
			pass
			# module_dict
		"Text":
			pass
			# module_dict
		"Option_Labels":
			pass
			# module_dict
		"Option_Gotos":
			pass
			# module_dict, space_dict, connection_dict
		_:
			pass

# fills the Godot Tree object with all the nested location nodes so the user knows what is inside what
func _display_regions_locations_tree():
	var root = region_tree.create_item()
	root.set_text(0, "Regions")
	# we'll loop through the module dict to display all the places
	if module_dict.has("Region"):
		for region in module_dict["Region"]:
			var child_region = region_tree.create_item(root)
			child_region.set_text(0, region["Name"]["Text"])
			child_region.set_metadata(0, region["Type"])
			if region.has("Location"):
				for location in region["Location"]:
					var child_location = region_tree.create_item(child_region)
					child_location.set_text(0, location["Name"]["Text"])
					child_location.set_metadata(0, location["Type"])
					if location.has("Space"):
						for space in location["Space"]:
							var child_space = region_tree.create_item(child_location)
							child_space.set_text(0, space["Id"]["Text"])
							child_space.set_metadata(0, space["Type"])

# creates a dictionary keyed by id of every space that stores connections to other spaces
# derived from module_dict
func _construct_space_dict(search_object, inside_space, space_id, current_location_array):
	if inside_space && nodes_with_text.has(search_object["Type"]) && search_object.has("Text"):
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
						# save the location this space is in the module dict for future access
						# this way, we won't need to search the whole tree every time we want to update a space object in the module_dict
						space_dict[space_id]["Path"] = current_location_array
					
				item = search_object[key]
			elif search_object is Array:
				item = key
			else:
				print("unexpected search object type: ", typeof(search_object))
				# can't quite figure out how to access the enum to just convert this to the key text, but you can just compare to Variant.Types in GlobalScope
			
			if !(item is String): # type is just for checking what sort of object we're in, and it doesn't need to be traversed
				current_location_array.append(key)
				_construct_space_dict(item, inside_space, space_id, current_location_array)
	else:
		print("unsearchable object: ", typeof(search_object), " " + search_object)

# unhighlights all spaces
func _unhighlight_everything(item):
	if item.get_metadata(0) != "Space":
		var child = item.get_children()
		while child != null:
			_unhighlight_everything(child)
			child = child.get_next()
	else:
		if space_dict[item.get_text(0)].has("SpaceObject"):
			var highlighted_space = space_dict[item.get_text(0)]["SpaceObject"]
			highlighted_space.unhighlight()

# highlights spaces selected in the Godot Tree object and their children
func _highlight_selected(selected_item):
	if selected_item.get_metadata(0) != "Space":
		var child = selected_item.get_children()
		while child != null:
			_highlight_selected(child)
			child = child.get_next()
	else:
		if space_dict[selected_item.get_text(0)].has("SpaceObject"):
			var highlighted_space = space_dict[selected_item.get_text(0)]["SpaceObject"]
			#now we have to actually highlight it
			highlighted_space.highlight()

# called when an object is selected in the Godot Tree object
func _on_RegionTree_item_selected():
	_unhighlight_everything(region_tree.get_root())
	_highlight_selected(region_tree.get_selected())
