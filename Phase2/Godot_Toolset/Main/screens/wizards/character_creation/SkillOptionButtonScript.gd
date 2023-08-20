extends OptionButton

var json_file = "res://test_scripts/test.json"

func _ready():
	var json_data = JSON.parse(json_file)
	var variables = json_data.get("variables")
	for variable in variables:
		add_item(variable["value"])

