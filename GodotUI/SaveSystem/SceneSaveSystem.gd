extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const SaveGame = preload('res://SaveSystem/GameSave.gd')

var SAVE_FOLDER : String = "res://SaveSystem/SaveLocations"
var SAVE_NAME_TEMPLATE : String = "save_%03D.tres"

func save(id : int):
	"""
	Passes a save game resource to all nodes to save data from and writes it to the disk
	Modfied from GDQuest's Godot Lesson Found Here: https://www.youtube.com/watch?v=ML-hiNytIqE
	"""
	var save_game := SaveGame.new()
	save_game.game_version = ProjectSettings.get_setting("application/config/version")
	for node in get_tree().get_nodes_in_group('save'):
		node.save(save_game)

	var directory : Directory = Directory.new()
	if not directory.dir.exists(SAVE_FOLDER):
		directory.make_dir_recursive(SAVE_FOLDER)
		
	var save_path = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE % id)
	var error : int = ResourceSaver.save(save_path, save_game)
	if error != OK:
		print('There was an issue writing the save %s to %s' % [id, save_path])	

func load(id : int):
	var save_file_path : String = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE % id)
	var file : File = File.new()
	if not file.file_exists(save_file_path):
		print("Save file %s doesn't exist" % save_file_path)
		return
	
	var save_game : Resource = load(save_file_path)
	for node in get_tree().get_nodes_in_group('save'):
		node.load(save_game)
	
	
