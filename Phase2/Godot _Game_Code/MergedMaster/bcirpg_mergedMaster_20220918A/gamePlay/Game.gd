#GAME: 
# Controls output space, loading descriptions and options for each locale and 
#	appending to the history array.

extends Control

#Source for module file:
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

var nodeArray

func _ready() -> void:
	theme=load(settings.themeFile)
	#Initialize module and display text:
	load_new_module()
	current_text.show()
	#Load character sheet:
	charSheet.text = pSingleton.pc.pcText
	
#Initializes the default module:
func load_new_module() -> void:
	var moduleDict = load_JSON_to_dict(module_file_path)
	var i = 0
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
	create_response(nodeArray[0].locale_description)

	clear_prior_options()
	i = 0
	for option in nodeArray[0].options_array:
		var destArr = nodeArray[0].destinations_array
		create_option(option, destArr[i])
		i = i+1
	options_container.get_child(0).grab_focus()

#Master method for handling user interaction:
func change_node(destinationNode: String, destinationParams: Array = []) -> void:
	var target_Locale = get_node_by_name(destinationNode)
	#Run provided action:
	if target_Locale.locale_action == "ShowText":
		action_show_text(target_Locale)
	elif target_Locale.locale_action == "RollDice" && target_Locale.destinations_array.size() == 1:
		action_roll_die(target_Locale)
	#DKM TEMP: testing passed param handling by node to node
	elif target_Locale.locale_action == "TestHandleNodeParams":
		action_handle_node_params_testing(target_Locale, destinationParams)
	#DKM TEMP: running an ability check test on passed node:
	elif target_Locale.locale_action == "TestAbstractAbilityCheck":
		action_ability_check_testing(target_Locale, destinationParams)

	options_container.get_child(0).grab_focus()


####################################################
#DISPLAY METHODS: 
#	Handles output text and options
####################################################
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
	var response_for_history = response.duplicate()
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

func _on_option_pressed(destinationSelected: String) -> void:
	#print("Destination node for pressed option is: " + destinationSelected)
	change_node(destinationSelected)


####################################################
#ACTION HANDLERS:
#	Process actions from selected nodes
####################################################
func action_show_text(newLocale: Locale) -> void:
	create_response(newLocale.locale_description)
	clear_prior_options()
	var i = 0
	for option in newLocale.options_array:
		var destArr = newLocale.destinations_array
		create_option(option, destArr[i])
		i = i+1
		
func action_roll_die(newLocale: Locale) -> void:
	print("Running test action " + newLocale.locale_action + "; with parameters of: ")
	var nodeParameters = []
	for param in newLocale.locale_action_params:
		print(param)
		nodeParameters.append(param)
	#DKM TEST: testing the die roller with Andrew's code; randomly assigning percentage to pass.
	#	Should this param be optional if you purely want to roll dice?
	var dieParams = nodeParameters
	DiceRoller.dieManager.clearData()
	DiceRoller.dieManager.setDieManager(dieParams, 0.5)
	var result = DiceRoller.dieManager.rollDice()
	print("Rolled values: " + str(result[0]))
	if(DiceRoller.dieManager.isPercentageRoll):
		var percDie =  int(result[1]*100)
		print("DKM TEMP: is percentage roll and perc res is: " + str(percDie))
		var perc_result = [percDie]
		change_node(newLocale.destinations_array[0], perc_result)
	else:
		change_node(newLocale.destinations_array[0], result[0])
		

#TESTING ACTIONS:
#Test version of ability check -- only built our for strength and agility with this output
func action_ability_check_testing(t_Locale: Locale, d_Params: Array = []) -> void:
	var check_result ="NA"
	print("Testing: passed stat is :" +t_Locale.locale_action_params[0])
	if(t_Locale.locale_action_params[0] in pSingleton.pc.viableCharStats):
		match t_Locale.locale_action_params[0]:
			"AG":
				if(int(d_Params[0])<= pSingleton.pc.agility):
					check_result = "PASS"		
				else:
					check_result = "FAIL"				
			"ST":
				if(int(d_Params[0])<= pSingleton.pc.strength):
					check_result = "PASS"		
				else:
					check_result = "FAIL"
			
	create_response(t_Locale.locale_description + check_result + " with roll of: " + str(d_Params) + "; on ability of: " + str(pSingleton.pc.strength))
	clear_prior_options()
	var i = 0
	for option in t_Locale.options_array:
		var destArr = t_Locale.destinations_array
		create_option(option, destArr[i])
		i = i+1
		
func action_handle_node_params_testing(t_Locale: Locale, d_Params: Array = []) -> void:
	create_response(t_Locale.locale_description + str(d_Params))
	clear_prior_options()
	var i = 0
	for option in t_Locale.options_array:
		var destArr = t_Locale.destinations_array
		create_option(option, destArr[i])
		i = i+1	

####################################################
#HELPER METHODS:
####################################################
func get_node_by_name(nodeName: String) -> Locale:
	for n in nodeArray:
		if n.locale_name == nodeName:
			return n
	return nodeArray[0]
	
#Convert JSON file to dictionary for module import:
#	DKM TEMP: JSON only for development work -- will come from alt data source
func load_JSON_to_dict(filepath:String)->Dictionary:
	var file = File.new()
	#assert file.file_exists(filepath)
	file.open(filepath,file.READ)
	var moduleDict = parse_json(file.get_as_text())
	#assert moduleDict.size() > 0
	return moduleDict

