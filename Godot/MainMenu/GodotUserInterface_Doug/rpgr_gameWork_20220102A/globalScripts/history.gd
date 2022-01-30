#HISTORY: 
#	Unique handler script for root history singleton.  May be adapted for 
#		history loading and saving functionality

extends Node
 

#DKM TEMP: not a cfg?
var history_file = "user://history.cfg"
var historyScreensSingleton = HistoryScreensTemplateSingleton.new()


func _ready() -> void:
	pass
	#load_history_file()
	
#Config/ini:
func load_history_file():
	var config = ConfigFile.new()
	# Load data from a file.
	var err = config.load(history_file)
	# If the file didn't load, ignore it.
	if err != OK:
		return
	for player in config.get_sections():
		var history_zero = config.get_value(player, "HistoryArray[0]")
		
		print("HistoryArray[0] loaded as: " + history_zero)
		
		historyScreensSingleton.output_history_array[0] = history_zero
