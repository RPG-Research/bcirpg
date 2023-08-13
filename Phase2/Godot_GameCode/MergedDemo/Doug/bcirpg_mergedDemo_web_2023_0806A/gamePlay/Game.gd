#GAME: 
# Controls output space, loading descriptions and options for each locale and 
#	appending to the history array.

extends Control

#Source for module file: to the GU
#export(String, FILE, "*.json") var module_file_path:String
#DKM TEMP:
var module_file_path = "res://_userFiles/Module_Demo_001.json"

onready var history_source = get_node("/root/History").historyScreensSingleton
onready var settings = get_node("/root/GlobalSaveInstance").settingsInstance

#Abstract class we instance when wanted in game as child of HistoryReference
const TextOutput = preload("res://UserInterface/Response.tscn")
const InputResponse = preload("res://UserInterface/InputResponse.tscn")
const OptionOutput = preload("res://UserInterface/Option.tscn")

onready var current_text = $Background/MarginContainer/Rows/GameInfo/CurrentText
onready var options_container = $Background/MarginContainer/Rows/InputArea/ScrollContainer/OptionsContainer
onready var pSingleton = get_node("/root/PlayerCharacter")
onready var charSheet = $Con_charSheet/MarginContainer/VBoxContainer/CharacterSheet


#DKM TEMP: this is just a temp file solution for grabbing map/module, will be replaced with DB
#	or desired load approach
onready var module_map = "res://_userFiles/temp_map.save"

var nodeArray

func _ready() -> void:
	save_module()
	theme=load(settings.themeFile)
	
	#DKM TEMP: testing:
	var moduleDict = loadJSONToDict(module_file_path)
	
	#DKM TEMP: this needs to be refactored to reposition this initialization
	var i = 0
	#print("Looking for JSON at: " + module_file_path)
	#print("Json returned as: " + str(moduleDict))
	var initialNode = Locale.new()
	nodeArray = [initialNode]
	for moduleNode in moduleDict.values():
		if nodeArray.size() <= i:
			var newNode = Locale.new()
			nodeArray.append(newNode)
		nodeArray[i].locale_name = moduleNode.get("Id")
		nodeArray[i].locale_description = moduleNode.get("Text")
		nodeArray[i].locale_action = moduleNode.get("Action")
		var actionParameters = moduleNode.get("A_Params")
		for p in actionParameters:
			nodeArray[i].locale_action_params.append(p)	
		var nodeOptions = moduleNode.get("Option_Labels")
		for option in nodeOptions:
			nodeArray[i].options_array.append(option)
			#print("For #" + str(i) + ": appended option of: " + str(option))
		var nodeDestinations = moduleNode.get("Option_GoTos")
		for dest in nodeDestinations:
			nodeArray[i].destinations_array.append(dest)
			#print("For #" + str(i) + ": appended go to destination of: " + str(dest))
		#print("Node array name for #" + str(i) + ": " + nodeArray[i].locale_name)
		i = i+1
	
	current_text.show()
	
	#Load character sheet:
	charSheet.text = pSingleton.pc.pcText
	
	create_response(nodeArray[0].locale_description)
	#DKM TEMP: another that needs to be broken out when ready:
	clear_prior_options()
	i = 0
	for option in nodeArray[0].options_array:
		var destArr = nodeArray[0].destinations_array
		create_option(option, destArr[i])
		i = i+1
	options_container.get_child(0).grab_focus()

#DKM TEMP: convert JSON file to dictionary for module import:
func loadJSONToDict(filepath:String)->Dictionary:
	var file = File.new()
	#assert file.file_exists(filepath)
	file.open(filepath,file.READ)
	var moduleDict = parse_json(file.get_as_text())
	#assert moduleDict.size() > 0
	return moduleDict


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

func clear_prior_options() -> void:
	for n in options_container.get_children():
		options_container.remove_child(n)
		n.queue_free()

func create_option(option: String, dest: String) -> void:
	#print("Received request to make option for label: " + option +"; and destination: " + dest)
	var optionNew = OptionOutput.instance()
	optionNew.destinationLabel = dest
	optionNew.text = option
	add_option_to_game(optionNew)

func add_option_to_game(optionNew: Control) -> void:
	options_container.add_child(optionNew)
	var newOptNumber = options_container.get_child_count()
	if newOptNumber-1 >= 0:
		#print("New added opt is: " + str(newOptNumber-1))
		options_container.get_child(newOptNumber-1).connect("option_pressed", self, "_on_option_pressed")

#DKM TEMP: these need to be dynamically added with the options themselves

func _on_option_pressed(destinationSelected: String) -> void:
	#print("Destination node for pressed option is: " + destinationSelected)
	change_node(destinationSelected)
	
func get_node_by_name(nodeName: String) -> Locale:
	for n in nodeArray:
		if n.locale_name == nodeName:
			return n
	return nodeArray[0]

func change_node(destinationNode: String, _destinationParams: Array = []) -> void:
	var target_Locale = get_node_by_name(destinationNode)
	
	#Run provided action:
	if target_Locale.locale_action == "ShowText":
		create_response(target_Locale.locale_description)
		#DKM TEMP: another that needs to be broken out when ready:
		clear_prior_options()
		var i = 0
		for option in target_Locale.options_array:
			var destArr = target_Locale.destinations_array
			create_option(option, destArr[i])
			i = i+1
	elif target_Locale.locale_action == "TestDieRollAction" && target_Locale.destinations_array.size() == 1:
		print("Running test action " + target_Locale.locale_action + "; with parameters of: ")
		var nodeParameters = []
		for param in target_Locale.locale_action_params:
			print(param)
			nodeParameters.append(param)
		#DKM TEST: testing the die roller with Andrew's code; randomly assigning percentage to pass.
		#	Should this param be optional if you purely want to roll dice?
		var dieParams = nodeParameters
		DiceRoller.dieManager.clearData()
		DiceRoller.dieManager.setDieManager(dieParams, 0.5)
		var result = DiceRoller.dieManager.rollDice()
		print("Rolled values: " + str(result[0]))

		#DKM TEMP: Andrew's code for ref:
		#assigning variable names to each of them for better clarity
#		var rolledValues = result[0]
#		var percentRolled = result[1]
#		var passResult = result[2]
#		var neededPercent = result[3]
#		var degreeOfSuccess = result[4]
#		var dice = result[5] 

		change_node(target_Locale.destinations_array[0])
	options_container.get_child(0).grab_focus()


#DKM TEMP: saves the entire scene in one packed scene file
func save_module():
		var scene = PackedScene.new()
		scene.pack(self)
		#var _saveResponse = ResourceSaver.save("user://game_01.tscn", scene)
		var _saveResponse = ResourceSaver.save("res://_userFiles/game_01.tscn", scene)
