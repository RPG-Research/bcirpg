extends Node


# initialize the DB connection.
# All Databases will be under res/databases/{Desired Database}

#How to init the connection with Godot 3.5+
#const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
#var db

#How to init the connection with godot 4+
var db : SQLite = null
const verbosity_level : int = SQLite.VERBOSE
var db_name = "res://databases/genre_sub"
#

#	An item will contain the ID of the item in question, followed by the genre name, and the alias provided.
#	Examples of how to use createItem
#   createItem("Melee-Weapon")
#	createItem("Dessert Ration Item")
#	createItem("Single Rider Vehicle")
func createItem(inputNameString):
	db.open_db()
	var tableName = "Item"
	var dict : Dictionary = Dictionary()
	dict["baseName"] = inputNameString
	db.insert_row(tableName,dict)
	print(dict)
	

#	A collection will contain the ID of the item in question, followed by the genre name, and the alias provided.
#	Examples of how to use createCollection
#   createCollection(3, "SciFi", "Plasma Pistol")
#	createCollection(3, "ModernDay", "9MM Handgun")
#	createCollection(3, "Fantasy", "Shortbow")
func createCollection(ItemID, collectionName, aliasName):
	db.open_db()
	var tableName = "Collection"
	var dict : Dictionary = Dictionary()
	dict["itemID"] = ItemID
	dict["collectionName"] = collectionName
	dict["itemAlias"] = aliasName
	db.insert_row(tableName,dict)
	print(dict)	
	

#	This will return all records under a genreName. 
#	Examples of how to use 
#   readCollectionByGenreName("SciFi")
#   readCollectionByGenreName("ModernDay")
#   readCollectionByGenreName("Fantasy")
func readCollectionByGenreName(feedName):
	db.open_db()
	var tableName = "Collection"
	db.query("select * from " + tableName + " where genreName = \"" + str(feedName) + "\"")
	for i in range(0, db.query_result.size()):
		print("TEST")
		print("Query results ", db.query_result[i]["itemAlias"], db.query_result[i]["primaryKey"])
	return db.query_result
	
	
#	This will return all Item records under an Item ID. 
#	Example of how to use 
#   read(3)
func readItemsByID(id):
	db.open_db()
	db.query("select Item.baseName as baseName, Collection.collectionName as genreName from Item left join Collection on Item.primaryKey = Collection.itemID where Item.primaryKey = " + str(id))
	for i in range(0, db.query_result.size()):
		print("Query results ", db.query_result[i]["baseName"], db.query_result[i]["genreName"])
	return db.query_result
	
#	This will read an Item record under your desired baseName. 
#	Examples of how to use readItemByBaseName
#   readItemByBaseName("sword")
func readIDByBaseName(feedName):
	db.open_db()
	var tableName = "Item"
	db.query("select primaryKey as itemIDKey from " + tableName  + " where baseName = \"" + str(feedName) + "\"");
	for i in range(0, db.query_result.size()):
		print("ID = ", db.query_result[i]["itemIDKey"])
	return db.query_result

	
#This will read all items in the entire database.
#Just call this function to return them.
func readItems():
	db.open_db()
	var tableName = "Item"
	db.query("select * from " + tableName)
	for i in range(0, db.query_result.size()):
		print("Query results ", db.query_result[i]["baseName"], db.query_result[i]["primaryKey"])
		

#	This will update an Item record under your desired ID. 
#	Example of how to use updateItemByID
#   updateItemByID(1, "Stringed Instrument")
func updateItemByID(id, feedName):
	db.open_db()
	var tableName = "item"
	db.query("update " + str(tableName) + " set baseName = " + "\"" + str(feedName) + "\"" + " where primaryKey = " + str(id) + ";")
	return db.query_result

#	This will update an Collection's Item Alias record under your desired ID. 
#	Example of how to use updateCollectionAliasByID
#   updateCollectionAliasByID(1, "Electric Guitar")
func updateCollectionAliasByID(id, feedName):
	db.open_db()
	var tableName = "collection"
	db.query("update " + str(tableName) + " set itemAlias = " + "\"" + str(feedName) + "\"" + " where primaryKey = " + str(id) + ";")
	return db.query_result


#	This will update an Collection's Genre Name record under your desired ID. 
#	Example of how to use updateCollectionGenreByID
#   updateCollectionGenreByID(1, "Cowboys VS Aliens")
func updateCollectionGenreByID(id, genreName):
	db.open_db()
	var tableName = "collection"
	db.query("update " + str(tableName) + " set genreName = " + "\"" + str(genreName) + "\"" + " where primaryKey = " + str(id) + ";")
	return db.query_result


#	This will delete an Item record under your desired ID. 
#	Examples of how to use deleteItemByID
#   deleteItemByID(2)
func deleteItemByID(id):
	db.open_db()
	var tableName = "Item"
	db.query("delete from " + tableName + " where primaryKey = " + str(id))
	print("Deleted Item by ID " + str(id) + ".")
	
	
#	This will delete a Collection record under your desired ID. 
#	Examples of how to use deleteCollectionByID
#   deleteCollectionByID(2)
func deleteCollectionByID(id):
	db.open_db()
	var tableName = "Collection"
	db.query("delete from " + tableName + " where primaryKey = " + str(id))
	print("Deleted Collection by ID " + str(id) + ".")	


# Called when the node enters the scene tree for the first time.
func _ready():
	db = SQLite.new()
	db.path = db_name
	updateCollectionGenreByID(1, "Cowboys VS Aliens")
	pass # Replace with function body.
