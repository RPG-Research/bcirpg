#DKM TEMP: placeholder for class related to game system lookups
#Methods here will take in player sheet and return the player sheet to output (string)
#Will handle going out and accessing the storage information

class_name Game_System_Layer

var game_dictionary
var library_path = "res://_userFiles/GSP_test.json"
var global_path_prefix = "res://globalScripts/"
var conversion_file_path = ""
#const Conversion_Source := preload("res://globalScripts/Convert_OPEND6.gd")
var game_options_label = "GAMES"
#Default is OpenD6
var game_system_used = "OPEND6_FANTASY"
var conversion_class = ""

#DKM TEMP: will search for Convert_{game_system_used} code in globals, and use percent if not found?
#	This will be used to get the output labels, output scores, and run ability conversions each way.
#func test() ->void:
#	Conversion_Source.print_HW()


#FUNCTION character sheet converter
#Params: the game we've selected, a char template (source char sheet), and if this is input. 
#	Otherwise output
#Returns: updated pc template, with either percentile abilities, or output fields set per this game system 
#	and the boolean direction indicated
func char_sheet_converter (game:String, source_char:playerCharacterTemplate, char_in:bool)->playerCharacterTemplate:
	if access_library() && game_dictionary[game_options_label].has(game):
		game_system_used = game
		if char_in:
			return _build_percentile_char(source_char)
		else:
			return _build_output_char(source_char) 
	else:
		return source_char

#FUNCTION build percentile character
#Params: the source char
#Returns: updated char sheet, with ability scores updated
#Notes: Assumes library can be accessed, game_dictionary has been
#	already written, and game system noted. Returns both ability score sets in the after/output char
func _build_percentile_char (source_char:playerCharacterTemplate)->playerCharacterTemplate:
	#Prior method
	#if source_char.output_labels.size() > 0 && source_char.output_labels.size() == source_char.output_scores_A.size():
	if source_char.player_capabilities.size() > 0:
		get_conversion_rules()
		print(conversion_class.get_HW())
		var ability_match_dict = conversion_class.get_ability_match()
		for key_perc_ab in ability_match_dict:
			var target_ab_1 =""
			var target_ab_2 =""
			var target_ab = ability_match_dict[key_perc_ab].get_slice("|", 0)
			var funct = ability_match_dict[key_perc_ab].get_slice("|", 1)
			#print("TEMP: I'm looking for: " + target_ab + "; to convert to: " + key_perc_ab + "; using function: " + funct)
			#For complex conversions, split needed abilities:
			if "/" in target_ab:
					target_ab_1 = target_ab.get_slice("/", 0)
					target_ab_2 = target_ab.get_slice("/", 1)
			#Now iterate and find the abilities for conversion:
			for player_cap in source_char.player_capabilities:
				#For capabilities added as additional:
				if(player_cap.Game_Name == null):
					player_cap.Game_Name = player_cap.name
					if(player_cap.Game_Raw == null):
						player_cap.Game_Raw = str(player_cap.score)
					var backendCap = source_char.duplicate_core_capability(player_cap)
					backendCap.score = conversion_class.FUNC_1(player_cap.Game_Raw)
					backendCap.Game_Name = "NA"
					source_char.player_capabilities.append(backendCap)	
					player_cap.Game_toDisplay = false
				if(player_cap.Game_Name.length() >0 && player_cap.Game_Name.strip_edges(true,true).to_upper() == target_ab.strip_edges(true,true).to_upper()):
					if (funct.strip_edges(true,true).to_upper() == "FUNC_1"):
						var backendCap = source_char.Capability_Source.new()
						backendCap.score = conversion_class.FUNC_1(player_cap.Game_Raw)
						backendCap.name = key_perc_ab.strip_edges(true,true).to_upper()
						backendCap.Game_Name = "NA"
						source_char.player_capabilities.append(backendCap)
						player_cap.Game_toDisplay = false
				#For 2 parters, preserve the first and go get the second:
				elif(player_cap.Game_Name.length() >0 && player_cap.Game_Name.strip_edges(true,true).to_upper() == target_ab_1.strip_edges(true,true).to_upper() && (funct.strip_edges(true,true).to_upper() == "FUNC_2")):
					var conversion_source1 = player_cap.Game_Raw
					for player_cap2 in source_char.player_capabilities:
						if(player_cap2.Game_Name.length() >0 && player_cap2.Game_Name.strip_edges(true,true).to_upper() == target_ab_2.strip_edges(true,true).to_upper()):
							var backendCap = source_char.Capability_Source.new()
							backendCap.score = conversion_class.FUNC_2(conversion_source1, player_cap2.Game_Raw)
							backendCap.name = key_perc_ab.strip_edges(true,true).to_upper()
							backendCap.Game_Name = "NA"
							source_char.player_capabilities.append(backendCap)
							player_cap2.Game_toDisplay = false
	print ("Printing perc: " + source_char.to_string_perc_PC())
	return source_char
	
#FUNCTION build output character
#Params: the source (percentile)
#Returns: the updated char sheet, with output fields written as needed
#Notes: Assumes library can be accessed, game_dictionary has been
#	already written, and game system noted. As above, returns both ability score sets in the after/output char
func _build_output_char (source_char:playerCharacterTemplate)->playerCharacterTemplate:
	return source_char


#FUNCTION Access Library
#Params: None now
#Returns: Successful connection or not
#Notes: This is a placeholder for whatever we're going to need to establish connection to go to the 
#	library on the server. As we are temporarily working from a JSON test, this is a local file 
#	within our built-in "user files." These populate our member variable for lookups. 
func access_library() -> bool:
	var file = File.new()
	var error = file.open(library_path, file.READ)
	if error != OK:
		print("Error accessing genre library ", error)
		return false
	else:
		game_dictionary = parse_json(file.get_as_text())
		return true
		

#FUNCTION: Get Game Options
#Params: None 
#Returns: Array containing game systems from library or empty
#Notes: None
func get_game_options() ->Array:
	var games = [];
	if(access_library()):
		for g in game_dictionary[game_options_label]:
			games.append(g)
		return games
	else:
		return games
	
#FUNCTION: Get Conversion Rules
#Params: None 
#Returns: Makes connection to conversion (TBD)
#Notes: None
func get_conversion_rules() ->void:
	var rules_test = "";
	conversion_file_path = global_path_prefix + "Convert_" + game_system_used + ".gd"
	var file = File.new()
	var error = file.open(conversion_file_path, file.READ)
	if error != OK:
		print("Error finding conversion rules in library " + error)
	else:
		var Conversion_Class := load(conversion_file_path)
		conversion_class = Conversion_Class.new()
