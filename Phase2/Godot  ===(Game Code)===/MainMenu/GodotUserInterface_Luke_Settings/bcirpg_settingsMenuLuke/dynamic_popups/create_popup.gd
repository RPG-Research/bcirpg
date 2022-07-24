extends Node

#Forked from the code found in this video
# https://www.youtube.com/watch?v=QnYtCSZR2iA


export var display_time: float = 5
export var display_text: String = "text"
export var error_code: int = 0

onready var popup_scene = load('res://dynamic_popups/popup.tscn')

func on_button_pressed():
	var new_popup = popup_scene.instance()
	new_popup.show_time = display_time
	new_popup.text_to_show = display_text
	add_child(new_popup)
