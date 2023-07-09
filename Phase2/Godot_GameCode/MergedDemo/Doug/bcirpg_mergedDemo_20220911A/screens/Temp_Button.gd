extends Button


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var tempToggle = 0

func _on_Button_button_up():
	var controlNode = get_node("../../")
	print(controlNode.name)
	if(tempToggle == 0):
		controlNode.theme=load("res://assets/ui_controlNode_dark_theme.tres")
		tempToggle = 1
	else:
		controlNode.theme=load("res://assets/ui_controlNode_light_theme.tres")
		tempToggle = 0
