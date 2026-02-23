extends Control

export var display_tree_path : NodePath
onready var display_tree = get_node(display_tree_path)

export var file_dialog_path : NodePath
onready var file_dialog = get_node(file_dialog_path)

var replacements_dict : Dictionary = {}
var genre_array : Array = [] # doesn't seem strictly necessary; for export into expected format


# Called when the node enters the scene tree for the first time.
func _ready():
	display_tree.set_hide_root(true)

func _get_data_as_json():
	var json_data = {"GENRES":genre_array, "REPLACEMENTS":replacements_dict}
	return to_json(json_data)
	
func _load_data_from_json(json_text):
	var parsed_json = parse_json(json_text)
	print(parsed_json)
	replacements_dict = parsed_json.get("REPLACEMENTS")
	genre_array = parsed_json.get("GENRES")

func _add_genre(genre_name : String):
	# add genre to genre_dict
	if (genre_array.has(genre_name)):
		print("that genre already exists!")
		return
		
	genre_array.append(genre_name)
	replacements_dict[genre_name] = {}

func _remove_genre(genre_name: String):
	# doesn't cause any problems if the genre_name isn't there
	genre_array.erase(genre_name)
	replacements_dict.erase(genre_name)

# also works to override an existing replacement; will add a genre if it doesn't exist because why not?
func _add_replacement(genre_name:String, generic:String, replacement:String):
	if !replacements_dict.has(genre_name):
		_add_genre(genre_name)
	replacements_dict[genre_name][generic] = replacement

func _remove_replacement(genre_name:String, generic:String):
	replacements_dict[genre_name].erase(generic)


func _fill_tree(): # why, yes, i am iterating through dicts. cry about it
	for genre in replacements_dict.keys():
		var genre_node = display_tree.create_item(display_tree.get_root())
		genre_node.set_text(0, genre)
		for generic in replacements_dict[genre].keys():
			var replacement = replacements_dict[genre][generic]
			var replacement_node = display_tree.create_item(genre_node)
			replacement_node.set_text(0, generic + " -> " + replacement)

func _refresh_tree():
	display_tree.clear()
	var root_node = display_tree.create_item()
	root_node.set_text(0,"Genres")


func _on_LoadButton_pressed():
	file_dialog.set_mode(FileDialog.MODE_OPEN_FILE)
	file_dialog.popup()

func _on_SaveButton_pressed():
	file_dialog.set_mode(FileDialog.MODE_SAVE_FILE)
	file_dialog.popup()

func _on_FileDialog_file_selected(path):
	var file = File.new()
	if file_dialog.get_mode() == FileDialog.MODE_OPEN_FILE:
		file.open(path, File.READ)
		var file_text = file.get_as_text()
		_load_data_from_json(file_text)
		_refresh_tree()
		_fill_tree()
	elif file_dialog.get_mode() == FileDialog.MODE_SAVE_FILE:
		if file.file_exists(path):
			print("existing file; jusst fyi it's gonna overwrite")
		file.open(path, File.WRITE)
		file.store_string(_get_data_as_json())
	file.close()
