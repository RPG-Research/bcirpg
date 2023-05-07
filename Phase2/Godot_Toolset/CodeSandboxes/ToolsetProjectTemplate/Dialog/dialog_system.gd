extends Node


# initialize the DB connection.
# All Databases will be under res/databases/{Desired Database}

#How to init the connection with Godot 3.5+
#const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
#var db

#How to init the connection with godot 4+
var db : SQLite = null
const verbosity_level : int = SQLite.VERBOSE
var db_name = "res://databases/dialog_system"
#


#	A tag is a string used to identify a dialog option.
#	Examples of how to use createTag
#   createItem("streetVendor1InMainCityGreetingA")
#	createItem("dreamSequence1EndingOptionB")
func createTag(inputNameString):
	db.open_db()
	var tableName = "Tag"
	var dict : Dictionary = Dictionary()
	dict["tagName"] = inputNameString
	db.insert_row(tableName,dict)
	print(dict)


#	A collection will contain the ID of the item in question, followed by the genre name, and the alias provided.
#	Examples of how to use createCollection
#   createCollection(3, "SciFi", "Plasma Pistol")
#	createCollection(3, "ModernDay", "9MM Handgun")
#	createCollection(3, "Fantasy", "Shortbow")
func createDialog(dialogText, tagID):
	db.open_db()
	var tableName = "Dialog"
	var dict : Dictionary = Dictionary()
	dict["dialogText"] = dialogText
	dict["tagID"] = tagID
	db.insert_row(tableName,dict)
	print(dict)	


#This will read all tags in the entire database.
#Just call this function to return them.
func readTags():
	db.open_db()
	var tableName = "Tag"
	db.query("select * from " + tableName)
	for i in range(0, db.query_result.size()):
		print("Query results ", db.query_result[i]["tagName"], db.query_result[i]["primaryKey"])
	return db.query_result
	
	
#This will read all Dialogs in the entire database.
#Just call this function to return them.
func readDialogs():
	db.open_db()
	var tableName = "Dialog"
	db.query("select * from " + tableName)
	for i in range(0, db.query_result.size()):
		print("Query results ", db.query_result[i]["dialogText"], db.query_result[i]["tagID"], db.query_result[i]["primaryKey"])
	return db.query_result	

#Updating a tab may be useful when the name needs to be changed.
#Example of how to use updateTagByID:
#updateTagByID(23, introToNPCLisa)	
func updateTagByID(id, feedText):
	db.open_db()
	var tableName = "Tag"
	db.query("update " + str(tableName) + " set tagName = " + "\"" + str(feedText) + "\"" + " where primaryKey = " + str(id) + ";")
	return db.query_result

#Updating a dialog option may be useful when the content or context needs to be changed.	
#Example of how to updateDialogByID
#updateDialogByID(47, "What'cha Buying, What'cha Selling?")
func updateDialogByID(id, feedText):
	db.open_db()
	var tableName = "Dialog"
	db.query("update " + str(tableName) + " set dialogText = " + "\"" + str(feedText) + "\"" + " where primaryKey = " + str(id) + ";")
	return db.query_result

#Example of how to updateTagByID
#updateTagByID(23)
func deleteTagByID(id):
	db.open_db()
	var tableName = "Tag"
	db.query("delete from " + tableName + " where primaryKey = " + str(id))
	print("Deleted Tag by ID " + str(id) + ".")
	
#Example of how to deleteDialogByID
#updateDialogByID(47)	
func deleteDialogByID(id):
	db.open_db()
	var tableName = "Dialog"
	db.query("delete from " + tableName + " where primaryKey = " + str(id))
	print("Deleted Dialog by ID " + str(id) + ".")	


# Called when the node enters the scene tree for the first time.
func _ready():
	db = SQLite.new()
	db.path = db_name
	deleteTagByID(2)
	deleteDialogByID(2)
	pass # Replace with function body.
