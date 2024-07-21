#DKM TEMP: placeholder for class related to game system lookups
#Methods here will take in player sheet and return the player sheet to output (string)
#Will handle going out and accessing the storage information

class_name Game_System_Layer

var game_dictionary
var library_path = "res://_userFiles/GSP_test.json"
const Conversion_Source := preload("res://globalScripts/Convert_OPEND6.gd")
var game_options_label = "GAMES"
#Default is OpenD6
var game_system_used = "OPEND6"

#DKM TEMP: will search for Convert_{game_system_used} code in globals, and use percent if not found?
#	This will be used to get the output labels, output scores, and run ability conversions each way.
func test() ->void:
	Conversion_Source.print_HW()


#FUNCTION character sheet converter
#Params: the game we've selected, a char template (source char sheet), and if this is input. 
#	Otherwise output
#Returns: a new pc template, with either percentile abilities, or output fields set per this game system 
#	and the boolean direction indicated
#Notes: We should probably pass this character by reference, but in GD Script, not sure what we're
#	dealing with here. So instead we'll pass the game selected, character source,  and take the values we need.
#	Looks up the needed converters, converts, and sends it back. If game not found, gives back original.
#	Direction bool matters as we're possibly overwriting what's there in the other set of abilities. 
func char_sheet_converter (game:String, source_char:playerCharacterTemplate, char_in:bool)->playerCharacterTemplate:
	if access_library() && game_dictionary[game_options_label].has(game):
		var output_char = playerCharacterTemplate.new()
		game_system_used = game
		if char_in:
			return _build_percentile_char(source_char, output_char)
		else:
			return _build_output_char(source_char, output_char)  
	else:
		return source_char

#FUNCTION build percentile character
#Params: the source char and the destination char
#Returns: the destination char sheet, with ability scores updated
#Notes: Assumes library can be accessed, game_dictionary has been
#	already written, and game system noted. Returns both ability score sets in the after/output char
func _build_percentile_char (before_char:playerCharacterTemplate, after_char:playerCharacterTemplate)->playerCharacterTemplate:
	return after_char
	
#FUNCTION build output character
#Params: the source (percentile) char and the destination (output) char
#Returns: the destination char sheet, with output fields written as needed
#Notes: Assumes library can be accessed, game_dictionary has been
#	already written, and game system noted. As above, returns both ability score sets in the after/output char
func _build_output_char (before_char:playerCharacterTemplate, after_char:playerCharacterTemplate)->playerCharacterTemplate:
	return after_char


#FUNCTION Access Library
#Params: None now
#Returns: Successful connection or not
#Notes: This is aplaceholder for whatever we're going to need to establish connection to go to the 
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
	
