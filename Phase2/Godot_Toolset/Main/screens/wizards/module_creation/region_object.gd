extends Control

class_name RegionObject

export var container_path: NodePath
onready var container = get_node(container_path)

func add_to_region_box(given_node):
	container.add_child(given_node)
