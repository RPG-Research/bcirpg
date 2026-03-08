extends ItemList


var selected_index


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("focus_entered", self, "_focus_entered")

func _input(event):
	if get_focus_owner() == self:
		if (event.is_action_pressed("ui_accept")):
			if selected_index < get_item_count()-1:
				selected_index += 1
			else:
				selected_index = 0
				
			print(selected_index)
			select(selected_index)
			accept_event()

func _focus_entered():
	if get_selected_items().empty():
		selected_index = 0
	else:
		selected_index = get_selected_items()[0]
