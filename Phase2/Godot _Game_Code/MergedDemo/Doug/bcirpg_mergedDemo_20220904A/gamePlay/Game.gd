#GAME: 
# Controls output space, loading descriptions and options for each locale and 
#	appending to the history array.

extends Control

#Source for module file: to the GU
#export(String, FILE, "*.json") var module_file_path:String
#DKM TEMP:
var module_file_path = "user://Module_Demo_001.json"

onready var history_source = get_node("/root/History").historyScreensSingleton
onready var settings = get_node("/root/GlobalSaveInstance").settingsInstance

#Abstract class we instance when wanted in game as child of HistoryReference
const TextOutput = preload("res://UserInterface/Response.tscn")
const InputResponse = preload("res://UserInterface/InputResponse.tscn")

onready var command_processor = $CommandProcessor
onready var current_text = $Background/MarginContainer/Rows/GameInfo/CurrentText
onready var history_pager = $Background/MarginContainer/Rows/ItemList/But_History_Page
onready var option_one = $Background/MarginContainer/Rows/InputArea/VBoxContainer/option1
onready var option_two= $Background/MarginContainer/Rows/InputArea/VBoxContainer/option2
onready var option_three = $Background/MarginContainer/Rows/InputArea/VBoxContainer/option3
onready var pSingleton = get_node("/root/PlayerCharacter")
onready var charSheet = $Con_charSheet/MarginContainer/VBoxContainer/CharacterSheet


#DKM TEMP: this is just a temp file solution for grabbing map/module, will be replaced with DB
#	or desired load approach
onready var module_map = "user://temp_map.save"

func _ready() -> void:
	save_module()
	theme=load(settings.themeFile)
	
	#DKM TEMP: testing:
	var moduleDict = loadJSONToDict(module_file_path)
	
	#DKM TEMP: this needs to be refactored to reposition this initialization
	var i = 0
	print("Looking for JSON at: " + module_file_path)
	print("Json returned as: " + str(moduleDict))
	var initialNode = Locale.new()
	var nodeArray = [initialNode]
	for moduleNode in moduleDict.values():
		if nodeArray.size() <= i:
			var newNode = Locale.new()
			nodeArray.append(newNode)
		nodeArray[i].locale_name = moduleNode.get("Id")
		nodeArray[i].locale_description = moduleNode.get("Text")
		var nodeOptions = moduleNode.get("Option_Labels")
		for option in nodeOptions:
			nodeArray[i].options_array.append(option)
			print("For #" + str(i) + ": appended option of: " + str(option))
		var nodeDestinations = moduleNode.get("Option_GoTos")
		for dest in nodeDestinations:
			nodeArray[i].destinations_array.append(dest)
			print("For #" + str(i) + ": appended go to destination of: " + str(dest))
		print("Node array name for #" + str(i) + ": " + nodeArray[i].locale_name)
		i = i+1
	
	current_text.show()
	option_one.show()
	
	#Load character sheet:
	charSheet.text = pSingleton.pc.pcText
	
	create_response(nodeArray[0].locale_description)
	#DKM TEMP: another that needs to be cleaned up:
	i = 0
	for option in nodeArray[0].options_array:
		var destArr = nodeArray[0].destinations_array
		add_option_to_game(option, destArr[i])
		i = i+1

#DKM TEMP: convert JSON file to dictionary for module import:
func loadJSONToDict(filepath:String)->Dictionary:
	var file = File.new()
	#assert file.file_exists(filepath)
	file.open(filepath,file.READ)
	var moduleDict = parse_json(file.get_as_text())
	#assert moduleDict.size() > 0
	return moduleDict



#Below temporarily takes user selection and appends it to responses; adding new instances 
#	of our input row with an input and response pair for each
func handleUserInput(user_choice: String) -> void:
	var input_response = InputResponse.instance()
	var inputText = "User selected: " + user_choice
	var response = command_processor.process_command(user_choice)
	input_response.set_text(inputText, response)
	add_response_to_game(input_response)
	
#Handles input text
func create_response(response_text: String):
	var response = TextOutput.instance()
	response.text = response_text
	add_response_to_game(response)	

#Copies the response output to add to both current game output, and the 
#	history array. 
func add_response_to_game(response: Control):
	add_response_to_history(response)
	if(current_text.get_child_count() > 0):
		current_text.remove_child(current_text.get_child(0))
	current_text.add_child(response)

func add_response_to_history(response: Control) -> void:
	#DKM TEMP: so here we
	#1. var response_history = response.duplicate()
	var response_for_history = response.duplicate()
	#2. get the history array from the singleton,
	#3. Add this to the history array
	history_source.output_history_array.append(response_for_history)

func add_option_to_game(option: String, dest: String) -> void:
	print("Received request to make option for label: " + option +"; and destination: " + dest)
	pass

#DKM TEMP: these need to be dynamically added with the options themselves
#func _on_option1_button_down() -> void:
#	var option1 = get_node("Background/MarginContainer/Rows/InputArea/VBoxContainer/option1")
#	handleUserInput(option1.get_text())
#
#
#func _on_option2_button_down() -> void:
#	var option2 = get_node("Background/MarginContainer/Rows/InputArea/VBoxContainer/option2")
#	handleUserInput(option2.get_text())
#
#
#func _on_option3_button_down() -> void:
#	var option3 = get_node("Background/MarginContainer/Rows/InputArea/VBoxContainer/option3")
#	handleUserInput(option3.get_text())


#func load_module():
#	var scene = load("user://save_01.tscn")
#	get_tree().change_scene_to(scene)

#DKM TEMP: saves the entire scene in one packed scene file
func save_module():
		var scene = PackedScene.new()
		scene.pack(self)
		ResourceSaver.save("user://game_01.tscn", scene)
