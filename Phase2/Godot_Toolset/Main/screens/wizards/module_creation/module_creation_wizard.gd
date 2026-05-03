extends Control


export var region_grid_path: NodePath
onready var region_grid = get_node(region_grid_path)

export var file_dialog_path: NodePath
onready var file_dialog = get_node(file_dialog_path)

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
		var nodes_with_text = ["Name", "Description", "Id", "Start", "Action", "A_Params", "Text", "Option_Labels_", "Option_GoTos_"]
		var nodes_with_multiples = ["Region", "Location", "Space"]
		
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
					var new_dict : Dictionary = {}
					
					# each element is added to the name stack so we know what element(s) we're inside
					node_name_stack.append(node_name)
					
					# a properly-formatted xml has only one root, and we have one dictionary to hold all the smaller dictionaries
					if node_name == "root":
						node_stack.append(new_dict)
					else:
						# first, we'll check if this is a node type that should be an array
						if nodes_with_multiples.has(node_name):
							# now that we know it should be an array, we'll check if the array already exists
							if !node_stack[-1].has(node_name):
								# if it doesn't, we'll make a new array
								node_stack[-1][node_name] = []
							# now we add to the new or existing array
							node_stack[-1][node_name].append(new_dict)
						else:
							# if there shouldn't be multiples, we add it directly, replacing any potential duplicates
							node_stack[-1][node_name] = new_dict
							
						# we always add the new dict to the node stack so we can add children to it directly
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
						node_stack.pop_back()
						# this might be the place to save something?
				XMLParser.NODE_TEXT:
					# first make sure we're in an element that should have text
					for text_node_label in nodes_with_text:
						if node_name_stack[-1].rstrip("0123456789")  == text_node_label:
							# this means we have a valid node for storing text
							var node_text = xml_parser.get_node_data()
							#print("adding text: " + node_text)
							node_stack[-1][node_name_stack[-1]] = node_text
	print(node_stack[0])
