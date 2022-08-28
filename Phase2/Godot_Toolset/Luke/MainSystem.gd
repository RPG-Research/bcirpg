extends Node

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db # Database object
var db_name = "res://DataStorage/database"

func CommitDataToDB():
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	var tableName = "DataStorage"
	var dict : Dictionary = Dictionary()
	dict["ConvoID"] = 1
	dict["LayerID"] = 1
	dict["BranchID"] = 1
	dict["Text"] = "The best riff from Freebird plays at 202 dB."
	
	db.insert_row(tableName,dict)

func readFromDB():
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	var tableName = "DataStorage"
	db.query("select * from " + tableName + ";")
	for i in range(0, db.query_result.size()):
		print("Query Results: ", db.query_result[i]["ConvoID"], db.query_result[i]["LayerID"], db.query_result[i]["BranchID"],db.query_result[i]["Text"])  


func DeleteFromDBByID(idNum):
	var idStr = str(idNum)
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	var tableName = "DataStorage"
	db.query("delete from " + tableName + " where ConvoID = " + idStr + ";")



# Called when the node enters the scene tree for the first time.
func _ready():
	DeleteFromDBByID(1)

