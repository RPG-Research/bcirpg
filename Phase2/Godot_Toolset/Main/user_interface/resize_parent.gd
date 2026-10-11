extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var is_dragging = false
var mouse_in_resize_area = false

export(bool) var resize_left = false
export(bool) var resize_right = false
export(bool) var resize_top = false
export(bool) var resize_bottom = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if resize_left || resize_right:
		set_default_cursor_shape(Control.CURSOR_HSIZE)
	if resize_top || resize_bottom:
		set_default_cursor_shape(Control.CURSOR_VSIZE)
	if (resize_left && resize_top) || (resize_right && resize_bottom):
		set_default_cursor_shape(Control.CURSOR_FDIAGSIZE)
	if (resize_left && resize_bottom) || (resize_right && resize_top):
		set_default_cursor_shape(Control.CURSOR_BDIAGSIZE)
	
	connect("mouse_entered", self, "_mouse_entered_resize_area")
	connect("mouse_exited", self, "_mouse_exited_resize_area")


func _mouse_entered_resize_area():
	mouse_in_resize_area = true
	
func _mouse_exited_resize_area():
	mouse_in_resize_area = false


func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			is_dragging = true
		elif event.is_released():
			is_dragging = false
	
	if mouse_in_resize_area && event is InputEventMouseMotion:
		if is_dragging:
			if resize_left:
				get_parent().margin_left += event.relative.x
			if resize_right:
				get_parent().margin_right += event.relative.x
			if resize_top:
				get_parent().margin_top += event.relative.y
			if resize_bottom:
				get_parent().margin_bottom += event.relative.y
