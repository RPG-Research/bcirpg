extends FileDialog

var directory
var filetree_node
var focus_array

var in_file_selection = false
var file_selection_focus_prev
var file_selection_focus_next

var file_path_array
var current_file_index

# Called when the node enters the scene tree for the first time.
func _ready():
	filetree_node = get_filetree_node()
	filetree_node.focus_mode = Control.FOCUS_ALL
	directory = Directory.new()
	

# TODO:
# unfocus prev/next node when entering file selection
# sort file array to matchbuilt-in sorting
# find a way to highlight folders the way files are highlighted
# handle selection
#	accept on file: exit file selection
#	accept on directory: more to directory, refresh file list
func _input(event):
	if is_visible():
		if (event.is_action("ui_focus_next") || event.is_action("ui_focus_prev")):
			var focused_node = get_focus_owner()
			
			if !in_file_selection:
				if event.is_action_released("ui_focus_next") && focused_node == file_selection_focus_prev:
					start_file_selection()
					current_file_index = 0
					set_current_path(file_path_array[current_file_index])
					accept_event()
				elif event.is_action_pressed("ui_focus_prev"):
					start_file_selection()
					current_file_index = file_path_array.size()-1
					set_current_path(file_path_array[current_file_index])
					accept_event()
			else: #in file selection
				if event.is_action_released("ui_focus_next"):
					current_file_index += 1
				elif event.is_action_released("ui_focus_prev"):
					current_file_index -= 1
				
				if current_file_index < 0:
					end_file_selection()
					accept_event()
					#file_selection_focus_prev.grab_focus()
				elif current_file_index >= file_path_array.size():
					end_file_selection()
					accept_event()
					#file_selection_focus_next.grab_focus()
				else:
					set_current_path(file_path_array[current_file_index])
					print("selected_file: " + file_path_array[current_file_index])
					accept_event()
					
		elif event.is_action("ui_accept") && in_file_selection:
			# selected is an existing directory
			if directory.dir_exists(file_path_array[current_file_index]):
				print("dir exists")
				set_current_dir(file_path_array[current_file_index])
				end_file_selection()
				start_file_selection()
				accept_event()
			

# horrible, hacky code
func get_filetree_node():
	for vbox_child in get_vbox().get_children():
		if vbox_child is MarginContainer:
			for margincontainer_child in vbox_child.get_children():
				if margincontainer_child is Tree:
					return margincontainer_child

func start_file_selection():
	file_path_array = []
	in_file_selection = true
	
	if directory.open(get_current_dir()) == OK:
		directory.list_dir_begin(true, true)
		var next_file = directory.get_next()
		while next_file != "":
			file_path_array.append(next_file)
			next_file = directory.get_next()
	print(file_path_array)
	

func end_file_selection():
	directory.list_dir_end()
	in_file_selection = false

func _on_FileDialog_visibility_changed():
	if is_visible():
		file_selection_focus_prev = filetree_node.find_prev_valid_focus()
		file_selection_focus_next = filetree_node.find_next_valid_focus()
