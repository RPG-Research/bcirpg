extends Node

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db # Database object
var db_name = "res://DataStorage/database"

onready var only_once : bool = true

onready var textEntry = get_node("VBoxContainer/LineEdit")
onready var convoID = get_node("VBoxContainer/HBoxContainer/labelConvoID/LineEdit")
onready var layerID = get_node("VBoxContainer/HBoxContainer/labelLayerID/LineEdit")
onready var branchID = get_node("VBoxContainer/HBoxContainer/labelBranchID/LineEdit")

onready var saveButton = get_node("saveButton")

func CommitDataToDB():
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	var tableName = "DataStorage"
	var dict : Dictionary = Dictionary()
	dict["ConvoID"] = int(convoID.text)
	dict["LayerID"] = int(layerID.text)
	dict["BranchID"] = int(branchID.text)
	dict["Text"] = textEntry.text
	
	db.insert_row(tableName,dict)
	
	print("Done with SQL commit")

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
	pass

func _process(delta):
	if saveButton.pressed == true && only_once == true:
		only_once = false
		CommitDataToDB()


