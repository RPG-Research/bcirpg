extends OptionButton

var option_popup

func _ready():
	option_popup = get_popup()

func _input(event):
	if get_focus_owner() == option_popup:
		if (event.is_action_pressed("ui_focus_prev")):
			if (option_popup.get_current_index() <= 0):
				option_popup.set_current_index(option_popup.get_item_count()-1)
			else:
				option_popup.set_current_index(option_popup.get_current_index()-1)
		elif (event.is_action_pressed("ui_focus_next")):
			if (option_popup.get_current_index() >= option_popup.get_item_count()-1):
				option_popup.set_current_index(0)
			else:
				option_popup.set_current_index(option_popup.get_current_index()+1)
