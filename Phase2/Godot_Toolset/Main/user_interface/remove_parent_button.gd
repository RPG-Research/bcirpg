extends Button

func _on_close_window_button_up():
	get_parent().queue_free()
