#BUT_QUIT:
# Unique script for ending a game. Will additionally perform or call needed 
#	shut down and close-out functionality.

extends Button


#DKM TEMP: save history is only here temporarily -- needs to move upstream.
func _on_But_Quit_button_up():
	_saveHistory()
	get_tree().quit()
	
func _saveHistory() -> void:
	var history = get_node("/root/History")
	var config = ConfigFile.new()
	
	#DKM TEMP: yet to parse out useful values
	var i = 0
	for page in history.historyScreensSingleton.output_history_array:
		config.set_value("Temp player history",str(i), page)
		i = i+1

	config.save("user://history.cfg")
