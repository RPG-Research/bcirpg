extends Control

class_name SpaceObject

onready var container = get_node("ScrollContainer/VBoxContainer")
onready var option_list = get_node("ScrollContainer/VBoxContainer/OptionList")

export var highlight_theme : Theme

signal highlight_destination_signal(destination_text)

func _ready():
	#self.connect("highlight_destination_signal", self, "_highlight_destination")
	pass

func add_to_space_box(given_node):
	container.add_child(given_node)
	container.move_child(option_list, container.get_child_count()-1) #just to keep option_list at the bottom

func get_space_box():
	return container

func add_field_pair_and_connect(field_name, field_text, caller, current_branch_key, key):
	var new_pair = HBoxContainer.new()
	var field_name_label = Label.new()
	var field_text_lineedit = LineEdit.new()
	new_pair.add_child(field_name_label)
	new_pair.add_child(field_text_lineedit)
			
	field_text_lineedit.size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_FILL
	field_text_lineedit.size_flags_vertical = Control.SIZE_EXPAND | Control.SIZE_FILL
	
	field_name_label.text = field_name
	field_text_lineedit.text = field_text
	
	add_to_space_box(new_pair)
	field_text_lineedit.connect("text_entered", caller, "_on_space_text_entered", [current_branch_key, key])
	return new_pair

func add_to_option_list(given_node):
	option_list.add_sortable_child(given_node)

func get_option_list():
	return option_list

func _gui_input(event):
	if event is InputEventMouseMotion && Input.is_mouse_button_pressed(BUTTON_LEFT):
		rect_position += event.relative

# if I click an action with a "Change_Location" action, I should highlight the location somehow
# that is, send an event that turns any action with the Id == A_Params into a different color

func get_destination():
	var is_change_location = false
	for item in container.get_children():
		if is_change_location == false:
			break
		if item is HBoxContainer:
			for subitem in item.get_children():
				if subitem.text == "ChangeLocation":
					is_change_location = true
					break
	var get_next_item = false
	var destination_text = null
	for item in container.get_children():
		if destination_text != null:
			break
		if item is HBoxContainer:
			for subitem in item.get_children():
				if subitem.text == "A_Params":
					get_next_item = true
				elif get_next_item == true:
					destination_text = subitem.text
					break
	if destination_text != null:
		emit_signal("highlight_destination_signal", destination_text) #tells the parent to tell all the children to check if they should be highlighted

# unused at the moment
func highlight_destination(destination_text):
	var destination_found = false
	var check_next_value = false
	for item in container.get_children():
		if destination_found:
			break
		if item is HBoxContainer:
			for subitem in item.get_children():
				if subitem.text == "Id":
					check_next_value = true
				elif check_next_value:
					check_next_value = false
					if subitem.text == destination_text:
						destination_found = true
						break
	
	if destination_found:
		self.theme = highlight_theme
	else:
		self.theme = null

func highlight():
	self.theme = highlight_theme

func unhighlight():
	self.theme = null
