extends Node

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db # Database object
var db_name = "res://DataStorage/database"

func CommitDataToDB():
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	var tableName = "DialogStorage"
	var dict : Dictionary = Dictionary()
	dict["ConvoID"] = 1
	dict["LayerID"] = 1
	dict["BranchID"] = 1
	dict["Text"] = "The best riff from Freebird plays at 202 dB."
	
	db.insert_row(tableName.dict)



# Called when the node enters the scene tree for the first time.
func _ready():
	CommitDataToDB()

