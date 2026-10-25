#HISTORY: 
#	Unique handler script for root history singleton.  May be adapted for 
#		history loading and saving functionality

extends Node
 

#DKM TEMP: not a cfg? **Cannot use user
#var history_file = "user://history.tres"
var history_file = "res://_userFiles.history.tres"
var historyScreensSingleton 
var testing = false

func _ready() -> void:
	if(testing):
		historyScreensSingleton = load_history_file()
	if (historyScreensSingleton == null):
			historyScreensSingleton = HistoryScreensTemplateSingleton.new()
	
	#DKM temp:
	print("Loaded history array size is: " + str(historyScreensSingleton.output_history_array.size()))

#The history array holds Controls that are never in the tree, so free them on quit.
func _exit_tree() -> void:
	for history_screen in historyScreensSingleton.output_history_array:
		if is_instance_valid(history_screen):
			history_screen.free()
	historyScreensSingleton.output_history_array.clear()

#DKM TEMP: load using tres format:
func load_history_file() -> HistoryScreensTemplateSingleton:
	if ResourceLoader.exists(history_file):
		var history = ResourceLoader.load(history_file)
		if history is HistoryScreensTemplateSingleton:
			return history		
		else: return null
	else:
		return null

