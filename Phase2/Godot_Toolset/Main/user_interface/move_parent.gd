extends Control


var mouse_in_move_area = false
var is_dragging = false


func _ready():
	connect("mouse_entered", self, "_mouse_entered_move_area")
	connect("mouse_exited", self, "_mouse_exited_move_area")

func _mouse_entered_move_area():
	mouse_in_move_area = true

func _mouse_exited_move_area():
	mouse_in_move_area = false
	
func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			is_dragging = true
		elif event.is_released():
			is_dragging = false
	
	if mouse_in_move_area && event is InputEventMouseMotion:
		if is_dragging:
			get_parent().rect_position += event.relative
