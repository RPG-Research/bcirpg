extends FileDialog

var directory
var filetree_node

var input_pressed

func _ready():
	input_pressed =  InputEventAction.new()
	filetree_node = get_filetree_node()
	filetree_node.focus_mode = Control.FOCUS_ALL
	directory = Directory.new()

func _input(event):
	if is_visible():
		if (event.is_action("ui_focus_next") || event.is_action("ui_focus_prev")):
			var in_filetree = false
			var focused_node = get_focus_owner()
			
			if filetree_node == focused_node:
				in_filetree = true
			
			#Here, we're emulating the ui_up and ui_down inputs because those already work with file dialogs.
			if in_filetree:
				if event.is_action_pressed("ui_focus_prev"):
					input_pressed.action = "ui_up"
					input_pressed.pressed = true
					Input.parse_input_event(input_pressed)
					accept_event()
				elif event.is_action_released("ui_focus_prev"):
					input_pressed.action = "ui_up"
					input_pressed.pressed = false
					Input.parse_input_event(input_pressed)
					accept_event()
				elif event.is_action_pressed("ui_focus_next"):
					input_pressed.action = "ui_down"
					input_pressed.pressed = true
					Input.parse_input_event(input_pressed)
					accept_event()
				elif event.is_action_released("ui_focus_next"):
					input_pressed.action = "ui_down"
					input_pressed.pressed = false
					Input.parse_input_event(input_pressed)
					accept_event()

# very hacky code
func get_filetree_node():
	for vbox_child in get_vbox().get_children():
		if vbox_child is MarginContainer:
			for margincontainer_child in vbox_child.get_children():
				if margincontainer_child is Tree:
					return margincontainer_child
