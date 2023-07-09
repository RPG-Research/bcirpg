extends Control

func _set_name(name) -> void:
	$Name.text = name

func _set_name_position(counterVal) -> void:
	$Name.rect_position.y = -225 + (50 * counterVal) 
