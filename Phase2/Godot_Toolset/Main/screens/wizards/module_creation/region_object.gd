extends Control

class_name RegionObject

onready var container = get_node("ScrollContainer/VBoxContainer")

func add_to_region_box(given_node):
	container.add_child(given_node)
