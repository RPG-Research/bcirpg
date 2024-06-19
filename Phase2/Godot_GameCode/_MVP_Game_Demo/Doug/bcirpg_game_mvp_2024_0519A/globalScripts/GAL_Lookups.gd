#Methods here will take in flagged generics and the genre to search for, access the library, 
#	lookup replacement and return it


class_name Genre_Layer

var genre_dictionary
var library_path = "res://_userFiles/GAL_test.json"
var replacements_label = "REPLACEMENTS"
var genre_options_label = "GENRES"

#FUNCTION genr-ify!
#Params: genre as a string, flagged generic to be replaced
#Returns: replacement value, or, if not found, original
#Notes: This is genre layer's wrapper method to call everything needed for this translation
func genrify (genre:String, generic:String)->String:
	if(access_library()):
		var replaced_value = generic
		if(genre_dictionary[replacements_label][genre].has(generic)):
			replaced_value = genre_dictionary[replacements_label][genre][generic]
			return replaced_value
		else:
			return generic
	else:
		return generic
	
	
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
		genre_dictionary = parse_json(file.get_as_text())
		return true


#FUNCTION: Get Genre Options
#Params: None 
#Returns: Array containing genres from library or empty
#Notes: None
func get_genre_options() ->Array:
	var genres = [];
	if(access_library()):
		for g in genre_dictionary[genre_options_label]:
			genres.append(g)
		return genres
	else:
		return genres
	
