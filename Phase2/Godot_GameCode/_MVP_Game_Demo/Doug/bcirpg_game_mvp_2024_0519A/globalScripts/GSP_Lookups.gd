#DKM TEMP: placeholder for class related to game system lookups
#Methods here will take in player sheet and return the player sheet to output (string)
#Will handle going out and accessing the storage information

class_name Game_System_Layer

var game_dictionary
var library_path = "res://_userFiles/GSP_test.json"
var game_options_label = "GAMES"

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
	
