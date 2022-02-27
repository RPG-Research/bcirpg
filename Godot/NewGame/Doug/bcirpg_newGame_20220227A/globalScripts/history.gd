#HISTORY: 
#	Unique handler script for root history singleton.  May be adapted for 
#		history loading and saving functionality

extends Node
 

#DKM TEMP: not a cfg?
var history_file = "user://history.tres"
var historyScreensSingleton 
var testing = false

func _ready() -> void:
	if(testing):
		historyScreensSingleton = load_history_file()
	if (historyScreensSingleton == null):
			historyScreensSingleton = HistoryScreensTemplateSingleton.new()
	
	#DKM temp:
	print("Loaded history array size is: " + str(historyScreensSingleton.output_history_array.size()))

#DKM TEMP: tres format:
func load_history_file() -> HistoryScreensTemplateSingleton:
	if ResourceLoader.exists(history_file):
		var history = ResourceLoader.load(history_file)
		if history is HistoryScreensTemplateSingleton:
			return history		
		else: return null
	else:
		return null

