extends OptionButton

var json_path = "res://test_scripts/testnew.json"

func _ready():
	_loadJSONToDict(json_path)

func _loadJSONToDict(filepath: String):
	var file = File.new()

	# Open the file for reading
	var error = file.open(filepath, File.READ)
	if error != OK:
		print("Error opening file:", filepath)

	# Read and parse the JSON content
	var json_text = file.get_as_text()
	file.close()  # Close the file after reading
	var moduleDict = parse_json(json_text)
	
	# Check if parsing was successful
	if moduleDict is Dictionary and moduleDict.size() > 0:
		print(moduleDict)
		var variables = moduleDict.get("items")
		for variable in variables:
			add_item(variable["value"])
		return moduleDict
	else:
		print("Error parsing JSON content")
