#HISTORY_VIEWER: 
# Controls output space -- will display the appropriate history array page. 
#	DKM TEMP: 5/15/22: what's here is replicated from the Game script for starting 
#		purposes. I have this working in experimental version -- will add this back
#		next. 

extends Control

onready var history_source = get_node("/root/History").historyScreensSingleton
onready var current_history = $Background/MarginContainer/Rows/GameInfo/CurrentHistory
onready var current_history_page_no = 0

#Abstract class we instance when wanted in game as child of HistoryReference
const TextOutput = preload("res://UserInterface/Response.tscn")
const InputResponse = preload("res://UserInterface/InputResponse.tscn")


func _ready() -> void:
	#DKM TEMP: for testing only -- this will be set in settings
	theme=load("res://assets/ui_controlNode_dark_theme.tres")
	#DKM_TEMP: display size of current history:
	print("Loaded history array size is: " + str(history_source.output_history_array.size()))


#Handles input text
func create_response(response_text: String):
	var response = TextOutput.instance()
	response.text = response_text
	add_response_to_game(response)	

#Copies the response output to add to both current game output, and the 
#	history array. 
func add_response_to_game(response: Control):
	if(current_history.get_child_count() > 0):
		current_history.remove_child(current_history.get_child(0))
	current_history.add_child(response)




