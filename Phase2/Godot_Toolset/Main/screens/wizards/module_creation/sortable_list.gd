extends VBoxContainer

var total_mouse_drag
# create an event for clicking and dragging each child?

func add_sortable_child(child_object):
	self.add_child(child_object)
	child_object.connect("gui_input", self, "_child_gui_input", [child_object])
	child_object.set_mouse_filter(Control.MOUSE_FILTER_STOP)

#func _gui_input(event):
#	print("input...")

func _child_gui_input(event, child):
	if !Input.is_mouse_button_pressed(BUTTON_LEFT):
		total_mouse_drag = Vector2(0,0)
	elif event is InputEventMouseMotion:
		total_mouse_drag += event.relative
		
		# while we can probably assume the children are all the same size, we probably shouldn't
		var prev_index = child.get_index()-1
		var next_index = child.get_index()+1
		
		if prev_index >= 0:
			var prev_object_height = get_child(prev_index).rect_size.y
			if -1*total_mouse_drag.y >= prev_object_height:
				move_child(child, prev_index)
				total_mouse_drag = Vector2(0,0)
		if next_index < get_child_count():
			var next_object_height = get_child(next_index).rect_size.y
			if total_mouse_drag.y >= next_object_height:
				move_child(child, next_index)
				total_mouse_drag = Vector2(0,0)
