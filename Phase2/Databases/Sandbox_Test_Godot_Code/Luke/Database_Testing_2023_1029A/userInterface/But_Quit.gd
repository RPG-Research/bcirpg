#BUT_QUIT:
# Unique script for ending a game. Will additionally perform or call needed 
#	shut down and close-out functionality.

extends Button

#var history_JSON = "user://history.json"


#DKM TEMP: save history is only here temporarily -- needs to move upstream.
func _on_But_Quit_button_up():
	get_tree().quit()
	
	
#JSON: requires dictionaries:
#func _saveHistory_JSON() -> void:
#	var history_screens_arr = get_node("/root/History").historyScreensSingleton.output_history_array
#	var file = File.new()
#	file.open(history_JSON, File.WRITE)
#	file.store_string(to_json(history_screens_arr))
#
#	file.close()
#	#	#DKM TEMP: 
#	print("Saved history array size should be: " + str(history_screens_arr.size()))
	
	
#DKM TEMP:
#tres file:
#func _saveHistory() -> void:
#	var history_screens = get_node("/root/History").historyScreensSingleton
#	assert(ResourceSaver.save("user://history.tres", history_screens)==OK)
#	#DKM TEMP: 
#	print("Saved history array size: " + str(history_screens.output_history_array.size()))
	
