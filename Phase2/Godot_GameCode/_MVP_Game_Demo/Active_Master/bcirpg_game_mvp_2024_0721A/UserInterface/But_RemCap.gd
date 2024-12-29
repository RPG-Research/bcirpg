extends Button

signal rem_cap_pressed(cap_setting)

var cap_setting

func _on_But_RemCap_button_up() -> void:
	print("Button pushed!")
	emit_signal("rem_cap_pressed", cap_setting)
