extends Control

export var zoom_subcontainer_path: NodePath
onready var zoom_subcontainer = get_node(zoom_subcontainer_path)

var zoom_speed = 0.01
var zoom_offset_power = 0.5

var is_dragging = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _gui_input(event):
	if event is InputEventMouseButton:
		var factor
		if event.factor == 0:
			factor = 1
		else:
			factor = event.factor
		
		if event.button_index == BUTTON_WHEEL_UP:
			zoom_subcontainer.rect_pivot_offset = lerp(zoom_subcontainer.rect_pivot_offset, get_global_mouse_position(), zoom_offset_power)
			zoom_subcontainer.rect_scale += factor*Vector2(zoom_speed, zoom_speed)
		elif event.button_index == BUTTON_WHEEL_DOWN:
			zoom_subcontainer.rect_pivot_offset = lerp(zoom_subcontainer.rect_pivot_offset, get_global_mouse_position(), zoom_offset_power)
			zoom_subcontainer.rect_scale -= factor*Vector2(zoom_speed, zoom_speed)
			
		elif event.pressed:
			is_dragging = true
		elif !event.pressed:
			is_dragging = false
					
	elif event is InputEventMouseMotion:
		if(is_dragging):
			zoom_subcontainer.rect_position += event.relative
