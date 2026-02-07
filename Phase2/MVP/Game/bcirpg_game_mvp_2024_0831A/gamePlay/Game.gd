#GAME: 
# Controls output space, loading descriptions and options for each locale and 
#	appending to the history array.

extends Control

#GAL is to hold instantiated Genre_Layer
const Genre_Layer := preload("res://globalScripts/GAL_Lookups.gd")
onready var GAL = Genre_Layer.new()
var generics_flag = "**"
var generics_word_header = "/"

#Source for module file: to the GU
#export(String, FILE, "*.json") var module_file_path:String
#DKM TEMP:
var module_file_path = "res://_userFiles/Module_Demo_001.json"
#DKM TEMP:
var module_file_path_xml = "res://_userFiles/Module_Demo_003_Loc.xml"

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

# --- Conflict / Turn system (d20) ---
var conflict_state = null  # Dictionary state machine or null
var conflict_return_node = ""  # where to go back after conflict ends
onready var ConflictMgr = preload("res://globalScripts/ConflictManagerD20.gd").new()

#Ability_Checker are used as passed by module and return Check_Results
const Ability_Checker_Source := preload("res://globalScripts/game_abilitychecks.gd")
onready var Ability_Checker = Ability_Checker_Source.new()

#DKM TEMP: this is just a temp file solution for grabbing map/module, will be replaced with DB
#	or desired load approach
onready var module_map = "res://_userFiles/temp_map.save"

#Name: nodeArray
#Use: Contains Locales of type SPACE for current location of the party in the game.
#	Location instance, instantiated from the UserInterface/Location.gd script.
var nodeArray
#Name: regionsArray
#Use: Contains Locales of type REGION, outermost Location level in the hierarchy. 
#	Regions contain Locations, which contain Spaces.
#	Each array item is a Location instance, instantiated from the UserInterface/Location.gd script.
var regionsArray

func _ready() -> void: 
	save_module()
	theme=load(settings.themeFile)
	
	#Sets a default button to grab focus
	#Node Builders should override this by setting the focused button to the first selectable option
	$Background/MarginContainer/Rows/ItemList/But_MoreOptions.grab_focus()
	
	#DKM TEMP: note the original JSON builder passes the starting space back, as it operates in a flat 
	#	location hierarchy. The XML builder implements a hierarchy of locations, and therefore returns
	#	the outermost layer as the regionsArray. Support for the JSON can be entirely removed when desired
	#	and all that code excised, but for now left in place for testing purposes. 
	#	Because of this hierarchy, the additional findStartingSpaceNode helper function is used within the
	#	runXML_NodeBuilder function.
	
	#nodeArray = runJSON_NodeBuilder(module_file_path)
	nodeArray = runXML_NodeBuilder(module_file_path_xml)
	
	current_text.show()
	#Load character sheet:
	if (settings.game_selection == "BCIRPG_PERCENTILE"):
		pSingleton.pc.to_string_perc_PC()
	else:
		pSingleton.pc.to_string_output_PC()
	charSheet.text = pSingleton.pc.pcText
	
	#DKM TEMP: 6/2/24 testing initial access of GAL code
	print("PERCENTILE CHAR print test: \n")
	print(pSingleton.pc.to_string_perc_PC())
	
	#var testWords = GAL.genrify(settings.Genre_Option.keys()[settings.genre_selection],"boat")
	#print("Sent test word of boat," + " and genre of " + settings.Genre_Option.keys()[settings.genre_selection] + "and got back: " + testWords)
	


#DKM TEMP: convert JSON file to dictionary for module import:
func loadJSONToDict(filepath:String)->Dictionary:
	var file = File.new()
	#assert file.file_exists(filepath)
	file.open(filepath,file.READ)
	var moduleDict = parse_json(file.get_as_text())
	#assert moduleDict.size() > 0
	return moduleDict


#FUNCTION Load XML Demo
#Params: File path to the location of the XML file
#Returns: Array of all game regions
#Notes: This is the XML version of the prior, JSON version to build the game provided source module material. 
#	Builds an array of Location of type REGION, the outermost layer on the location hierarchy, with all contained 
#	Locations and all contained Spaces. At this time there is no support for a separate layer of type of Scene, 
#	though this can be added as desired. 
func loadXMLDemo(filepath:String)->Array:
	
	#Array to hold all regions for the module (of type Location)
	var regions_XML = []
	#To hold our current Region node
	var newNode
	
	var parser_ext = XMLParser.new()
	var error = parser_ext.open(filepath)
	if error != OK:
		print("Error opening XML file ", error)
		return regions_XML

	#Region iterator
	var i=0

	while parser_ext.read() == OK:
		if parser_ext.get_node_type() == XMLParser.NODE_ELEMENT:
			var node_name = parser_ext.get_node_name()
		
			if node_name.strip_edges(true,true).to_upper() == "REGION":
				newNode = Locale.new()
				newNode.locale_type = node_name.strip_edges(true,true).to_upper()
				
				while parser_ext.read() == OK:
					if parser_ext.get_node_type() == XMLParser.NODE_ELEMENT:
						var child_node_name_raw = parser_ext.get_node_name().strip_edges(true,true).to_upper()
						var child_node_name = child_node_name_raw
						match child_node_name:
							"NAME":
								parser_ext.read()
								if parser_ext.get_node_type() == XMLParser.NODE_TEXT:	
									var id_node_data = parser_ext.get_node_data()							
									newNode.locale_name = id_node_data.strip_edges(true,true)
							"DESCRIPTION":
								parser_ext.read()
								if parser_ext.get_node_type() == XMLParser.NODE_TEXT:	
									var id_node_data = parser_ext.get_node_data()							
									newNode.locale_description = id_node_data.strip_edges(true,true)	
							"LOCATION":
								var locationNode = loadLocationNode(parser_ext)
								newNode.contained_subLocations.append(locationNode)		
					elif parser_ext.get_node_type() == XMLParser.NODE_ELEMENT_END && parser_ext.get_node_name().strip_edges(true,true).to_upper() == "REGION":
						#print ("End of region found")
						regions_XML.append(newNode)
						i = i+1
				
	return regions_XML


#FUNCTION Load Location Node
#Params: Currently validated XML parser
#Returns: A new Locale of type LOCATION, with name and description and contained children
#Notes: This calls the space node creator as needed; also bubbles up starting location if found in the spaces contained
func loadLocationNode(parser:XMLParser)->Locale:
	var newLocationNode = Locale.new()
	#Our spaces per location node iterator
	var j=0
	while parser.read() == OK:
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			var loc_child_node_name_raw = parser.get_node_name().strip_edges(true,true).to_upper()
			var loc_child_node_name = loc_child_node_name_raw
			match loc_child_node_name:
				"NAME":
					parser.read()
					if parser.get_node_type() == XMLParser.NODE_TEXT:	
						var loc_id_node_data = parser.get_node_data()							
						newLocationNode.locale_name = loc_id_node_data.strip_edges(true,true)
				"DESCRIPTION":
					parser.read()
					if parser.get_node_type() == XMLParser.NODE_TEXT:	
						var loc_id_node_data = parser.get_node_data()							
						newLocationNode.locale_description = loc_id_node_data.strip_edges(true,true)	
				"SPACE":
					var spaceNode = loadGameNode(parser)
					#Starting locale is set to the specific space node, but the location that holds this node will also be flagged.
					if spaceNode.is_starting_locale == true:
						newLocationNode.is_starting_locale = true
					newLocationNode.contained_subLocations.append(spaceNode)
				
		elif parser.get_node_type() == XMLParser.NODE_ELEMENT_END && parser.get_node_name().strip_edges(true,true).to_upper() == "LOCATION":
			#print ("End of location " + newLocationNode.locale_name + " found")
			break
			
	return newLocationNode


#FUNCTION Load Game Node
#Params: currently validated XML parser
#Returns: A new Locale of type SPACE, with elements (ID, action, options and options labels) contained
#Notes:
func loadGameNode(parser:XMLParser)->Locale:
	var node_name = parser.get_node_name()
	var spaceNode = Locale.new()
	spaceNode.locale_type = "SPACE"

	while parser.read() == OK:
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			var child_node_name_raw = parser.get_node_name().strip_edges(true,true).to_upper()
			var child_node_name = child_node_name_raw
			
			#print("TEMP: debug child name: " + child_node_name)
			
			#DKM TEMP/TODO: Note that the code currently expects an even number of labels and go-tos, 
			#		and in the correct order. Ideally we split on the underscore, match the numbers
			#		and handle cases of mismatches (by number mismatch or failure to match numbers of 
			#		labels with numbers of gotos. But for now works as JSON version did.
			#		I'm using the child_node_name_raw to preserve the full name with suffix number if we 
			#		want to use.
			#		NOTE: XMLParser throws errors on get node name and type if not within the expected
			#			type; these are being checked against in the match after read, but not output.
			#
			if "OPTION_LABELS" in child_node_name_raw:
				child_node_name = "OPTION_LABELS"
			elif "OPTION_GOTOS" in child_node_name_raw:
				child_node_name = "OPTION_GOTOS"
			match child_node_name:
				"ID":
					parser.read()
					if parser.get_node_type() == XMLParser.NODE_TEXT:
						var id_node_data = parser.get_node_data()
						spaceNode.locale_name = id_node_data.strip_edges(true,true)
						print("LOADED SPACE:", spaceNode.locale_name)
				"START":
					parser.read()
					if (parser.get_node_type() == XMLParser.NODE_TEXT) && (parser.get_node_data().strip_edges(true,true).to_upper() == "TRUE"):								
						#print("Found Starting place!")
						spaceNode.is_starting_locale  = true					
				"ACTION":
					parser.read()
					if parser.get_node_type() == XMLParser.NODE_TEXT:
						var action_node_data = parser.get_node_data()
						spaceNode.locale_action = action_node_data.strip_edges(true,true)
						print("  ACTION =", spaceNode.locale_action)
				"TEXT":
					parser.read()
					if parser.get_node_type() == XMLParser.NODE_TEXT:								
						var descr_node_data = parser.get_node_data()
						spaceNode.locale_description  = descr_node_data.strip_edges(true,true)
				"OPTION_LABELS":
					parser.read()
					if parser.get_node_type() == XMLParser.NODE_TEXT:								
						var action_node_data = parser.get_node_data()
						spaceNode.options_array.append(action_node_data.strip_edges(true,true))
					
				"OPTION_GOTOS":
					parser.read()
					if parser.get_node_type() == XMLParser.NODE_TEXT:								
						var action_node_data = parser.get_node_data()
						spaceNode.destinations_array.append(action_node_data.strip_edges(true,true))
						
				"A_PARAMS":
					parser.read()
					if parser.get_node_type() == XMLParser.NODE_TEXT:
						var action_node_data = parser.get_node_data()
						spaceNode.locale_action_params.append(action_node_data.strip_edges(true,true))
		elif parser.get_node_type() == XMLParser.NODE_ELEMENT_END && parser.get_node_name().strip_edges(true,true).to_upper() == "SPACE":
			#print ("End of space " + spaceNode.locale_name + " found")
			break

	return spaceNode

#FUNCTION Find Starting Space Node
#Params: regions XML array: array of all game regions (outermost location level)
#Returns: XML of the contained sublocations for a location holding the starting node
#Notes: This helper function iterates the built regions and returns the contained sublocations from the Location level 
#	area that contains the starting space flagged.
func findStartingSpaceNode(regions:Array)->Array:
	var startingSpaces_XML = []
	if regions.size() < 1:
		return startingSpaces_XML
	else:
		for x in regions:
			#Location level
			for y in x.contained_subLocations:
				if y.is_starting_locale == true:
					startingSpaces_XML = y.contained_subLocations
	
	return startingSpaces_XML
	
#FUNCTION: Run XML Node Builder
#Params: File path to the location of the XML file
#Returns: Array of Locales of type SPACE that contain the isStartingLocale node. 
#Notes: This is a wrapper function to load from the XML. It begins with initial
#	option loading, and finds the starting place, populating the global Regions 
#	Array so it may be accessed for changing regions.
func runXML_NodeBuilder(module_file_path:String)->Array:
	regionsArray = loadXMLDemo(module_file_path_xml) 
	var nodeArray_XML = findStartingSpaceNode(regionsArray)
	create_response(nodeArray_XML[0].locale_description)
	#DKM TEMP: another that needs to be broken out when ready:
	clear_prior_options()
	var i = 0
	for option in nodeArray_XML[0].options_array:
		var destArr = nodeArray_XML[0].destinations_array
		create_option(option, destArr[i])
		i = i+1
	if options_container.get_child_count() > 0:
		options_container.get_child(0).grab_focus()

	return nodeArray_XML


func runJSON_NodeBuilder(module_file_path:String)->Array:
	var nodeArray_JSON
	var moduleDict = loadJSONToDict(module_file_path)
	#DKM TEMP: this needs to be refactored to reposition this initialization
	var i = 0
	#print("Looking for JSON at: " + module_file_path)
	#print("Json returned as: " + str(moduleDict))
	var initialNode = Locale.new()
	nodeArray_JSON = [initialNode]
	for moduleNode in moduleDict.values():
		if nodeArray_JSON.size() <= i:
			var newNode = Locale.new()
			nodeArray_JSON.append(newNode)
		nodeArray_JSON[i].locale_name = moduleNode.get("Id")
		nodeArray_JSON[i].locale_description = moduleNode.get("Text")
		nodeArray_JSON[i].locale_action = moduleNode.get("Action")
		var actionParameters = moduleNode.get("A_Params")
		for p in actionParameters:
			nodeArray_JSON[i].locale_action_params.append(p)	
		var nodeOptions = moduleNode.get("Option_Labels")
		for option in nodeOptions:
			nodeArray_JSON[i].options_array.append(option)
			#print("For #" + str(i) + ": appended option of: " + str(option))
		var nodeDestinations = moduleNode.get("Option_GoTos")
		for dest in nodeDestinations:
			nodeArray_JSON[i].destinations_array.append(dest)
			#print("For #" + str(i) + ": appended go to destination of: " + str(dest))
		#print("Node array name for #" + str(i) + ": " + nodeArray[i].locale_name)
		i = i+1
	create_response(nodeArray_JSON[0].locale_description)
	#DKM TEMP: another that needs to be broken out when ready:
	clear_prior_options()
	i = 0
	for option in nodeArray_JSON[0].options_array:
		var destArr = nodeArray_JSON[0].destinations_array
		create_option(option, destArr[i])
		i = i+1
	if options_container.get_child_count() > 0:
		options_container.get_child(0).grab_focus()

	
	return nodeArray_JSON

#FUNCTION: Flags fix
#Params: Any string to be checked
#Returns: String with generics replaced
#Notes: This looks for generics flag, currently marked above, and if found, genrifies 
#	that word if possible, and if not, returns the string with flags removed
func flags_fix(input_text:String)->String:
	if(generics_flag in input_text):
		var output_text =""
		var output_source_arr = input_text.split(generics_flag, false)
		var output_arr =[]
		for section in output_source_arr:
			if(section.find(generics_word_header) == 0):
				#output_arr.append(GAL.genrify(settings.Genre_Option.keys()[settings.genre_selection],section.substr(1,-1)))
				output_arr.append(GAL.genrify(settings.genre_selection,section.substr(1,-1)))
			else:
				output_arr.append(section)
		for section in output_arr:
			output_text = output_text + section
		return output_text
	else:
		return input_text

#Handles input text
func create_response(response_text: String):
	var out_text = flags_fix(response_text)
	var response = TextOutput.instance()
	response.text = out_text
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
	optionNew.text = flags_fix(option)
	add_option_to_game(optionNew)

func add_option_to_game(optionNew: Control) -> void:
	options_container.add_child(optionNew)
	var newOptNumber = options_container.get_child_count()
	if newOptNumber-1 >= 0:
		#print("New added opt is: " + str(newOptNumber-1))
		options_container.get_child(newOptNumber-1).connect("option_pressed", self, "_on_option_pressed")

#DKM TEMP: these need to be dynamically added with the options themselves

func _on_option_pressed(destinationSelected: String) -> void:
	# If we are inside a conflict flow, options are "CONFLICT:*" tokens, not locale names.
	print("OPTION CLICKED:", destinationSelected)
	if conflict_state != null and destinationSelected.begins_with("CONFLICT:"):
		_handle_conflict_choice(destinationSelected)
		return
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
	elif target_Locale.locale_action == "ChangeLocation" && target_Locale.destinations_array.size() == 1:
		print("Running test action " + target_Locale.locale_action + "; with parameters of: ")
		var nodeParameters = []
		var outputText = "Stepping over to: "
		for param in target_Locale.locale_action_params:
			print(param)
			nodeParameters.append(param)
		if (target_Locale.locale_action_params.size() == 3):
			var destination = findRelocationLocation(nodeParameters)
			print ("TEMP: returned destination of: " + destination.locale_name)
			create_response(destination.locale_description)
			clear_prior_options()
			var p = 0
			for option in destination.options_array:
				var destArr = destination.destinations_array
				create_option(option, destArr[p])
				p = p+1
	#DKM TEMP: This is a test of the new ability check class and check result.
	elif target_Locale.locale_action == "TestAbilityCheck" && target_Locale.destinations_array.size() == 1:
		print("Running test action " + target_Locale.locale_action)
		var nodeParameters = []
		var ability_to_use = target_Locale.locale_action_params[0]
		var modifier_to_check = target_Locale.locale_action_params[1]
		var outputText = "Ability to be checked: " + str(ability_to_use) + "; at mod of " + str(modifier_to_check)
		
		var results_of_check = Ability_Checker.make_player_check(str(ability_to_use),int(modifier_to_check)) 

		outputText = outputText + "; with result (true pass; false fail) of check being: " + str(results_of_check.check_pass) +"; on a roll of: " + str(results_of_check.rolled)
		create_response(outputText)
	
	elif target_Locale.locale_action == "AbilityCheck_Conditional" && target_Locale.destinations_array.size() == 2:
		print("Running conditional ability check " + target_Locale.locale_action)
		create_response(target_Locale.locale_description)
		var nodeParameters = []
		var ability_to_use = target_Locale.locale_action_params[0]
		var modifier_to_check = target_Locale.locale_action_params[1]
		var results_of_check = Ability_Checker.make_player_check(str(ability_to_use),int(modifier_to_check)) 
		clear_prior_options()
		
		if !(results_of_check.check_pass):
			create_option(target_Locale.options_array[0], target_Locale.destinations_array[0])
		else:
			create_option(target_Locale.options_array[1], target_Locale.destinations_array[1])
		
		
		
	elif target_Locale.locale_action == "TestDieRollAction" && target_Locale.destinations_array.size() == 1:
		print("Running test action " + target_Locale.locale_action + "; with parameters of: ")
		var nodeParameters = []
		var outputText = "Die types to be rolled: "
		for param in target_Locale.locale_action_params:
			print(param)
			outputText = outputText + str(param) + " sided; "
			nodeParameters.append(param)
		#DKM TEST: testing the die roller with Andrew's code; randomly assigning percentage to pass.
		#	Should this param be optional if you purely want to roll dice?
		var dieParams = nodeParameters
		DiceRoller.dieManager.clearData()
		DiceRoller.dieManager.setDieManager(dieParams, 0.5)
		var result = DiceRoller.dieManager.rollDice()
		print("Rolled values: " + str(result[0]))
		outputText = outputText + "with values: " + str(result[0])
		create_response(outputText)
		#DKM TEMP: Andrew's code for ref:
		#assigning variable names to each of them for better clarity
#		var rolledValues = result[0]
#		var percentRolled = result[1]
#		var passResult = result[2]
#		var neededPercent = result[3]
#		var degreeOfSuccess = result[4]
#		var dice = result[5] 


	# --- NEW: d20 conflict hooks (see diagrams) ---
	elif target_Locale.locale_action == "StartSimpleConflict":
		# Store where to return after the conflict finishes (optional)
		if target_Locale.destinations_array.size() > 0:
			conflict_return_node = target_Locale.destinations_array[0]
		else:
			conflict_return_node = ""

		_start_simple_conflict(target_Locale.locale_action_params)
		return
	elif target_Locale.locale_action == "StartExtendedConflict":
		print(">>> HIT StartExtendedConflict <<<")
		if target_Locale.destinations_array.size() > 0:
			conflict_return_node = target_Locale.destinations_array[0]
		else:
			conflict_return_node = ""

		_start_extended_conflict(target_Locale.locale_action_params)
		return
		#change_node(target_Locale.destinations_array[0])
	if options_container.get_child_count() > 0:
		options_container.get_child(0).grab_focus()


#FUNCTION: Find Relocation Location
#Params: array containing the names of target: 0.region, 1.location, 2.space
#Returns: the target location
#Notes: This is a helper function to look up desired location by name. 
func findRelocationLocation(locNames:Array)->Locale:
	var relocated_location = Locale.new()
	if locNames.size() == 3:
		for region in regionsArray:
			print("TEMP: region name read as: " + region.locale_name)
			if (region.locale_name.strip_edges(true,true).to_upper() == locNames[0].strip_edges(true,true).to_upper()):
				for loc in region.contained_subLocations:
					if (loc.locale_name.strip_edges(true,true).to_upper() == locNames[1].strip_edges(true,true).to_upper()):
						for space in loc.contained_subLocations:
							print("TEMP: space name read as: " + space.locale_name)
							if (space.locale_name.strip_edges(true,true).to_upper() == locNames[2].strip_edges(true,true).to_upper()):
								relocated_location = space
	return relocated_location

#DKM TEMP: saves the entire scene in one packed scene file
func save_module():
		var scene = PackedScene.new()
		scene.pack(self)
		#var _saveResponse = ResourceSaver.save("user://game_01.tscn", scene)
		var _saveResponse = ResourceSaver.save("res://_userFiles/game_01.tscn", scene)


# ---------------------------------------------------------------------------
# d20 Conflict / Turn System implementation (MVP)
# This section implements the flow in your diagrams without changing your UI:
# we re-use the existing OptionsContainer buttons by emitting destinations that
# start with "CONFLICT:".
#
# Godot 3.5 compatible.
# ---------------------------------------------------------------------------

func _start_simple_conflict(params: Array) -> void:
	# params (optional): [npc_name]
	var npc_name = "Bandit"
	if params.size() > 0:
		npc_name = str(params[0])

	var npc = ConflictMgr.make_default_npc(npc_name)
	conflict_state = {
		"mode": "simple",
		"step": "choose_intent",
		"pc_intent": "",
		"pc_trait": "",
		"npc_intent": "",
		"npc_trait": "",
		"npc": npc
	}
	create_response("[Conflict] Choose your intent (talk / move / do / fight).")
	clear_prior_options()
	_render_conflict()

func _start_extended_conflict(params: Array) -> void:
	var npc_name = "Bandit"
	if params.size() > 0:
		npc_name = str(params[0])

	var npc = ConflictMgr.make_default_npc(npc_name)
	conflict_state = {
		"mode": "extended",
		"step": "initiative",
		"round": 1,
		"turn": "",
		"distance": 1, # 1 = in melee range (MVP)
		"pc_turn": {"moved": false, "acted": false},
		"pc_status": {"hidden": false, "dodging": false, "disengaged": false, "helping": false, "reaction": ""},
		"npc": npc
	}
	create_response("[Combat] Extended conflict started. Rolling initiative…")
	clear_prior_options()
	_render_conflict()

func _handle_conflict_choice(token: String) -> void:
	# token format: CONFLICT:<type>:<value>
	var parts = token.split(":", false)
	if parts.size() < 3:
		return
	var kind = parts[1]
	var value = parts[2]

	if conflict_state == null:
		return

	match conflict_state["mode"]:
		"simple":
			_handle_simple_choice(kind, value)
		"extended":
			_handle_extended_choice(kind, value)
		_:
			pass

func _render_conflict() -> void:
	if conflict_state == null:
		return
	match conflict_state["mode"]:
		"simple":
			_render_simple()
		"extended":
			_render_extended()
		_:
			pass

# --- SIMPLE CONFLICT (Diagram 1) -------------------------------------------

func _render_simple() -> void:
	clear_prior_options()
	match conflict_state["step"]:
		"choose_intent":
			create_option("Talk", "CONFLICT:intent:talk")
			create_option("Move", "CONFLICT:intent:move")
			create_option("Do", "CONFLICT:intent:do")
			create_option("Fight", "CONFLICT:intent:fight")
		"choose_trait":
			var intent = conflict_state["pc_intent"]
			create_response("[Conflict] Using what? Pick a trait for intent: " + intent)
			var caps = _pc_caps_dict()
			var group = ConflictMgr.intent_cap_group(intent)
			for cap_name in group:
				if caps.has(cap_name):
					create_option(cap_name, "CONFLICT:trait:" + cap_name)
			create_option("Back", "CONFLICT:nav:back")
		"end":
			create_option("Continue", "CONFLICT:end:ok")
		_:
			create_option("Continue", "CONFLICT:end:ok")

func _handle_simple_choice(kind: String, value: String) -> void:
	match kind:
		"intent":
			conflict_state["pc_intent"] = value
			conflict_state["step"] = "choose_trait"
			_render_conflict()
		"trait":
			conflict_state["pc_trait"] = value
			_resolve_simple_conflict()
			conflict_state["step"] = "end"
			_render_conflict()
		"nav":
			if value == "back":
				conflict_state["step"] = "choose_intent"
				_render_conflict()
		"end":
			# exit conflict and go back
			var return_to = conflict_return_node
			conflict_state = null
			conflict_return_node = ""
			if return_to != "":
				change_node(return_to)
			else:
				# If no return node provided, just rebuild current node options by doing nothing.
				pass
		_:
			pass

func _resolve_simple_conflict() -> void:
	var pc_intent = str(conflict_state["pc_intent"])
	var pc_trait = str(conflict_state["pc_trait"])

	# NPC chooses an intent (MVP AI) and best matching trait
	var npc_intents = ["talk", "move", "do", "fight"]
	randomize()
	var npc_intent = npc_intents[randi() % npc_intents.size()]
	conflict_state["npc_intent"] = npc_intent

	var npc = conflict_state["npc"]
	var npc_trait = _npc_best_trait(npc, npc_intent)
	conflict_state["npc_trait"] = npc_trait

	# Calculate trait mods (Diagram: Trait Mods -> Total Mods)
	var pc_percent = _pc_get_percent(pc_trait)
	var npc_percent = _npc_get_percent(npc, npc_trait)

	var roll = ConflictMgr.contested_roll(pc_percent, npc_percent, 0, 0)

	var pc_total = roll["pc"]["total"]
	var npc_total = roll["npc"]["total"]
	var margin = int(roll["margin"])
	var outcome = str(roll["outcome"])

	var winner = "TIE"
	if margin > 0:
		winner = "PC"
	elif margin < 0:
		winner = "NPC"


	var msg = "[Conflict Result]\n"
	msg += "PC intent: %s (using %s)\n" % [pc_intent, pc_trait]
	msg += "NPC intent: %s (using %s)\n" % [npc_intent, npc_trait]
	msg += "PC roll %d + mod %d = %d\n" % [roll["pc"]["roll"], roll["pc"]["mod"], pc_total]
	msg += "NPC roll %d + mod %d = %d\n" % [roll["npc"]["roll"], roll["npc"]["mod"], npc_total]
	msg += "Outcome: %s (margin %d) => %s\n" % [winner, margin, outcome]

	# If it's a fight intent for either side, apply a tiny MVP damage to show the loop works
	if pc_intent == "fight" or npc_intent == "fight":
		var dmg = 1 + int(abs(margin) / 5)
		if outcome == "CRIT_SUCCESS" or outcome == "CRIT_FAIL":
			dmg += 2
		if margin > 0:
			_npc_take_damage(conflict_state["npc"], dmg)
			msg += "PC hits %s for %d damage. NPC HP now %d.\n" % [npc["name"], dmg, npc["hp"]]
		elif margin < 0:
			_pc_take_damage(dmg)
			msg += "NPC hits PC for %d damage. PC HP now %d.\n" % [dmg, _pc_get_hp()]
		else:
			msg += "No damage (tie).\n"

	create_response(msg)

# --- EXTENDED CONFLICT (Diagrams 2/3/4) ------------------------------------

func _render_extended() -> void:
	clear_prior_options()
	match conflict_state["step"]:
		"initiative":
			# Initiative Order (Diagram 2)
			var npc = conflict_state["npc"]
			var roll = ConflictMgr.contested_roll(_pc_get_percent("AG"), _npc_get_percent(npc, "AG"), 0, 0)
			if int(roll["margin"]) >= 0:
				conflict_state["turn"] = "pc"
			else:
				conflict_state["turn"] = "npc"

			create_response("[Initiative] PC total %d vs NPC total %d. %s goes first." % [roll["pc"]["total"], roll["npc"]["total"], conflict_state["turn"].to_upper()])
			conflict_state["step"] = "turn_start"
			create_option("Continue", "CONFLICT:flow:next")
		"turn_start":
			# Reset per-turn flags
			conflict_state["pc_turn"] = {"moved": false, "acted": false}
			# Clean up some one-turn statuses
			conflict_state["pc_status"]["helping"] = false
			conflict_state["pc_status"]["reaction"] = ""
			var npc = conflict_state["npc"]
			create_response("[Round %d] PC HP %d | %s HP %d" % [conflict_state["round"], _pc_get_hp(), npc["name"], npc["hp"]])
			if conflict_state["turn"] == "pc":
				conflict_state["step"] = "pc_choose"
				_render_extended()
			else:
				conflict_state["step"] = "npc_act"
				create_option("Continue", "CONFLICT:flow:next")
		"pc_choose":
			# Action Declaration (Diagram 2) + list from Diagram 3
			create_response("[Your turn] Choose action (you may Move + 1 Action).")
			create_option("Move", "CONFLICT:act:move")
			create_option("Attack", "CONFLICT:act:attack")
			create_option("Hide", "CONFLICT:act:hide")
			create_option("Dodge", "CONFLICT:act:dodge")
			create_option("Disengage", "CONFLICT:act:disengage")
			create_option("Help", "CONFLICT:act:help")
			create_option("Set reaction", "CONFLICT:act:reaction")
			create_option("Spell", "CONFLICT:act:spell")
			create_option("Flee", "CONFLICT:act:flee")
			# Only allow End Turn if you already moved or acted
			var moved = conflict_state["pc_turn"]["moved"]
			var acted = conflict_state["pc_turn"]["acted"]
			if moved or acted:
				create_option("End turn", "CONFLICT:act:endturn")
		"npc_act":
			create_response(_npc_take_turn())
			conflict_state["turn"] = "pc"
			conflict_state["round"] += 1
			conflict_state["step"] = "turn_start"
			create_option("Continue", "CONFLICT:flow:next")
		"end":
			create_option("Continue", "CONFLICT:end:ok")
		_:
			create_option("Continue", "CONFLICT:end:ok")

func _handle_extended_choice(kind: String, value: String) -> void:
	if kind == "flow":
		_render_conflict()
		return
	if kind == "end":
		var return_to = conflict_return_node
		conflict_state = null
		conflict_return_node = ""
		if return_to != "":
			change_node(return_to)
		return
	if kind != "act":
		return

	match value:
		"move":
			conflict_state["pc_turn"]["moved"] = true
			create_response("[Move] You reposition. (MVP: distance stays " + str(conflict_state["distance"]) + ")")
			conflict_state["step"] = "pc_choose"
			_render_conflict()
		"attack":
			conflict_state["pc_turn"]["acted"] = true
			create_response(_pc_attack_npc())
			if _check_combat_end():
				conflict_state["step"] = "end"
				_render_conflict()
			else:
				conflict_state["step"] = "pc_choose"
				_render_conflict()
		"hide":
			conflict_state["pc_turn"]["acted"] = true
			create_response(_pc_try_hide())
			conflict_state["step"] = "pc_choose"
			_render_conflict()
		"dodge":
			conflict_state["pc_turn"]["acted"] = true
			conflict_state["pc_status"]["dodging"] = true
			create_response("[Dodge] Until your next turn, attacks against you are harder.")
			conflict_state["step"] = "pc_choose"
			_render_conflict()
		"disengage":
			conflict_state["pc_turn"]["acted"] = true
			conflict_state["pc_status"]["disengaged"] = true
			create_response("[Disengage] You avoid opportunity attacks this round (MVP flag).")
			conflict_state["step"] = "pc_choose"
			_render_conflict()
		"help":
			conflict_state["pc_turn"]["acted"] = true
			conflict_state["pc_status"]["helping"] = true
			create_response("[Help] You set up an ally (MVP: stored as a flag).")
			conflict_state["step"] = "pc_choose"
			_render_conflict()
		"reaction":
			conflict_state["pc_turn"]["acted"] = true
			conflict_state["pc_status"]["reaction"] = "basic_reaction"
			create_response("[Set reaction] Reaction set (MVP placeholder).")
			conflict_state["step"] = "pc_choose"
			_render_conflict()
		"spell":
			conflict_state["pc_turn"]["acted"] = true
			create_response("[Spell] Spell casting placeholder (hook your spell system here).")
			conflict_state["step"] = "pc_choose"
			_render_conflict()
		"flee":
			create_response("[Flee] You leave the conflict.")
			conflict_state["step"] = "end"
			_render_conflict()
		"endturn":
			conflict_state["turn"] = "npc"
			conflict_state["step"] = "npc_act"
			_render_conflict()
		_:
			pass

func _pc_attack_npc() -> String:
	# Conflict Results Process (Diagram 2):
	# - Situational modifiers: e.g., target dodging/hidden etc.
	# - Defender vs Opponent results matrix => we use margin tiers.
	var npc = conflict_state["npc"]
	var situ_pc = 0
	var situ_npc = 0
	if npc["status"]["dodging"]:
		situ_pc -= 2
	var roll = ConflictMgr.contested_roll(_pc_get_percent("ST"), _npc_get_percent(npc, "AG"), situ_pc, situ_npc)
	var margin = int(roll["margin"])
	var outcome = str(roll["outcome"])

	var msg = "[Attack]\n"
	msg += "PC %d vs NPC %d (margin %d => %s)\n" % [roll["pc"]["total"], roll["npc"]["total"], margin, outcome]

	if margin > 0:
		var dmg = 2 + int(margin / 5)
		if outcome == "CRIT_SUCCESS":
			dmg += 3
		_npc_take_damage(npc, dmg)
		msg += "Hit! Dealt %d damage. %s HP now %d." % [dmg, npc["name"], npc["hp"]]
	else:
		msg += "Miss."
	return msg

func _npc_take_turn() -> String:
	var npc = conflict_state["npc"]
	# Very simple AI for MVP:
	# - if PC is hidden, NPC tries to "search" (opposed IN vs AG)
	# - else NPC attacks (opposed ST vs AG) with penalty if PC is dodging
	if conflict_state["pc_status"]["hidden"]:
		var roll = ConflictMgr.contested_roll(_npc_get_percent(npc, "IN"), _pc_get_percent("AG"), 0, 0)
		if int(roll["margin"]) > 0:
			conflict_state["pc_status"]["hidden"] = false
			return "[NPC] %s spots you! (You are no longer hidden)" % npc["name"]
		return "[NPC] %s searches but can’t find you." % npc["name"]

	var situ_npc = 0
	if conflict_state["pc_status"]["dodging"]:
		situ_npc -= 2
	var roll2 = ConflictMgr.contested_roll(_npc_get_percent(npc, "ST"), _pc_get_percent("AG"), situ_npc, 0)
	var margin2 = int(roll2["margin"])  # NPC - PC
	# NOTE: contested_roll returns margin as PC - NPC by default, so invert meaning here
	# We called with (npc, pc) as (pc_percent, npc_percent) in the function, so margin is NPC - PC.
	if margin2 > 0:
		var dmg = 2 + int(margin2 / 5)
		if str(roll2["outcome"]) == "CRIT_SUCCESS":
			dmg += 3
		_pc_take_damage(dmg)
		if _pc_get_hp() <= 0:
			return "[NPC] %s hits you for %d damage. You are defeated." % [npc["name"], dmg]
		return "[NPC] %s hits you for %d damage. PC HP now %d." % [npc["name"], dmg, _pc_get_hp()]
	return "[NPC] %s attacks but misses." % npc["name"]

func _pc_try_hide() -> String:
	var npc = conflict_state["npc"]
	var roll = ConflictMgr.contested_roll(_pc_get_percent("AG"), _npc_get_percent(npc, "IN"), 0, 0)
	if int(roll["margin"]) > 0:
		conflict_state["pc_status"]["hidden"] = true
		return "[Hide] Success. You are hidden."
	return "[Hide] Failed. They keep track of you."

func _check_combat_end() -> bool:
	var npc = conflict_state["npc"]
	if npc["hp"] <= 0:
		create_response("[Combat] %s is defeated." % npc["name"])
		return true
	if _pc_get_hp() <= 0:
		create_response("[Combat] You are defeated.")
		return true
	return false

# --- PC/NPC stat helpers ----------------------------------------------------

func _pc_caps_dict() -> Dictionary:
	var d = {}
	var p = PlayerCharacter.pc
	if p == null:
		return d
	for cap in p.player_capabilities:
		d[str(cap.name)] = int(cap.score) + int(cap.modifier)
	return d

func _pc_get_percent(cap_name: String) -> int:
	var p = PlayerCharacter.pc
	if p == null:
		return 0
	for cap in p.player_capabilities:
		if str(cap.name).to_upper() == cap_name.to_upper():
			return int(cap.score) + int(cap.modifier)
	return 0

func _pc_get_hp() -> int:
	var p = PlayerCharacter.pc
	if p == null:
		return 0
	for cap in p.player_capabilities:
		if str(cap.name) == "Health":
			return int(cap.score)
	return 0

func _pc_take_damage(dmg: int) -> void:
	var p = PlayerCharacter.pc
	if p == null:
		return
	for cap in p.player_capabilities:
		if str(cap.name) == "Health":
			cap.score = int(cap.score) - int(dmg)
			return

func _npc_get_percent(npc: Dictionary, cap_name: String) -> int:
	if npc.has("caps") and npc["caps"].has(cap_name):
		return int(npc["caps"][cap_name])
	return 0

func _npc_best_trait(npc: Dictionary, intent: String) -> String:
	var group = ConflictMgr.intent_cap_group(intent)
	var best = ""
	var best_val = -999
	for cap_name in group:
		var v = _npc_get_percent(npc, cap_name)
		if v > best_val:
			best_val = v
			best = cap_name
	if best != "":
		return best
	return group[0]


func _npc_take_damage(npc: Dictionary, dmg: int) -> void:
	npc["hp"] = int(npc["hp"]) - int(dmg)
