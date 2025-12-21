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
# find a way to highlight folders the way files are highlighted
func _input(event):
	if is_visible():
		if (event.is_action("ui_focus_next") || event.is_action("ui_focus_prev")):
			var focused_node = get_focus_owner()
			
			if !in_file_selection:
				# important note: any time a ui_focus_prev event comes through, so does a ui_focus next
				# I assume this is because ui_focus nex is bound to tab and prev is bound to shift+tab
				if event.is_action_pressed("ui_focus_prev"):
					if focused_node == file_selection_focus_next:
						start_file_selection()
						current_file_index = file_path_array.size()-1
						set_current_path(file_path_array[current_file_index])
						release_focus()
						accept_event()
				elif event.is_action_pressed("ui_focus_next"):
					if focused_node == file_selection_focus_prev:
						start_file_selection()
						current_file_index = 0
						set_current_path(file_path_array[current_file_index])
						release_focus()
						accept_event()
			else: #in file selection
				if event.is_action_pressed("ui_focus_prev"):
					current_file_index -= 1
				elif event.is_action_pressed("ui_focus_next"):
					current_file_index += 1
				
				if current_file_index < 0:
					end_file_selection()
					file_selection_focus_prev.call_deferred("grab_focus")
					accept_event()
					#file_selection_focus_prev.call_deferred("grab_focus")
				elif current_file_index >= file_path_array.size():
					end_file_selection()
					file_selection_focus_next.call_deferred("grab_focus")
					accept_event()
					#file_selection_focus_next.call_deferred("grab_focus")
				else:
					set_current_path(file_path_array[current_file_index])
					accept_event()
					
		elif event.is_action_pressed("ui_accept") && in_file_selection:
			# selected is an existing directory
			if directory.dir_exists(file_path_array[current_file_index]):
				set_current_dir(file_path_array[current_file_index])
				end_file_selection()
				start_file_selection()
				current_file_index = 0
				accept_event()
			# if the selected item is a file, we can keep the default behavior
			

# very hacky code
func get_filetree_node():
	for vbox_child in get_vbox().get_children():
		if vbox_child is MarginContainer:
			for margincontainer_child in vbox_child.get_children():
				if margincontainer_child is Tree:
					return margincontainer_child

func start_file_selection():
	in_file_selection = true
	
	if directory.open(get_current_dir()) == OK:
		# get all the file paths and put them in an array with directories first
		var dir_array_temp = []
		var file_array_temp = []
		
		directory.list_dir_begin(true, true)
		var next_file = directory.get_next()
		while next_file != "":
			if directory.dir_exists(next_file):
				dir_array_temp.append(next_file)	
			elif directory.file_exists(next_file):
				file_array_temp.append(next_file)
			next_file = directory.get_next()
		
		file_path_array = dir_array_temp
		file_path_array.append_array(file_array_temp)
	

func end_file_selection():
	directory.list_dir_end()
	in_file_selection = false

func _on_FileDialog_visibility_changed():
	if is_visible():
		file_selection_focus_prev = filetree_node.find_prev_valid_focus()
		file_selection_focus_next = filetree_node.find_next_valid_focus()
		start_file_selection()
		current_file_index = 0
