extends Node


const save_file = "user://save_file.json"

var save_data = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	save_data = get_data()

func get_data():
	var file = File.new()
	
	if not file.file_exists(save_file):
		save_data = {"player_name": "Unnamed"}
		save_game()
	file.open(save_file, File.READ)
	var content = file.get_as_text()
	var data = parse_json(content)
	save_data = data
	file.close()
	return(data)
	
func save_game():
	var save_game = File.new()
	save_game.open(save_file, File.WRITE)
	save_game.store_line(to_json(save_data))
