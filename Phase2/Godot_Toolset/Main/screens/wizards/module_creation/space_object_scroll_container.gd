extends ScrollContainer

var scrolling = false

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP || event.button_index == BUTTON_WHEEL_DOWN:
			# we want to check if scrolling is necessary
			if get_child(0).rect_size.y > self.rect_size.y: #if the child is too small to need scrolling, don't block the input
				self.accept_event()
