extends ColorRect
class_name Draggable

var id: int
var label: String
# set this to true once we've been dropped on our target
var dropped_on_target: bool = false


func _ready() -> void:
	add_to_group("DRAGGABLE")
	$Label.text = label


func get_drag_data(_position: Vector2):
	print("[Draggable] get_drag_data has run")
	if not dropped_on_target:
		set_drag_preview(_get_preview_control())
		return self


func _on_item_dropped_on_target(draggable):
	print("[Draggable] Signal item_dropped_on_target received")
	if draggable.get("id") != id:
		return
	print("[Draggable] Iven been dropped, removing myself from source container")
	queue_free()


func _get_preview_control() -> Control:
	"""
	The preview control must not be in the scene tree. You should not free the control, and
	you should not keep a reference to the control beyond the duration of the drag.
	It will be deleted automatically after the drag has ended.
	"""
	var preview = ColorRect.new()
	preview.rect_size = rect_size
	var preview_color = color
	preview_color.a = .5
	preview.color = preview_color
	preview.set_rotation(.1) # in readians
	return preview
