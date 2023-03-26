extends Node


# initialize the DB connection.
# All Databases will be under res/databases/{Desired Database}
const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://databases/genre_sub"



#	An item will contain the ID of the item in question, followed by the genre name, and the alias provided.
#	Examples of how to use createItem
#   createItem("Melee-Weapon")
#	createCollection("Dessert Ration Item")
#	createCollection("Single Rider Vehicle")

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
	


#Not to sure about this one. We may need to talk about a refactor here	
func createGenreSubstitutionLayer(collectionID):
	db.open_db()
	var tableName = "Genre_Substitution_Layer"
	var dict : Dictionary = Dictionary()
	dict["collectionID"] = collectionID
	db.insert_row(tableName,dict)
	print(dict)	
	

func getItemsByID(id):
	db.open_db()
	db.query("select Item.baseName as baseName, Collection.collectionName as genreName from Item left join Collection on Item.primaryKey = Collection.itemID where Item.primaryKey = " + str(id))
	for i in range(0, db.query_result.size()):
		print("Query results ", db.query_result[i]["baseName"], db.query_result[i]["genreName"])
	return db.query_result
	

# TO DO: Modify this query to provide a list of all items, that use the refer to the same base item; using item.baseName as the query item

#func getItemsByBaseName(feedName):
#	db.open_db()
#	db.query("select Item.baseName as baseName, Collection.collectionName as genreName from Item left join Collection on Item.primaryKey = Collection.itemID where Item.primaryKey = " + str(feedName))
#	for i in range(0, db.query_result.size()):
#		print("Query results ", db.query_result[i]["baseName"], db.query_result[i]["genreName"])
#	return db.query_result
	
	
func readItem():
	db.open_db()
	var tableName = "Item"
	db.query("select * from " + tableName)
	for i in range(0, db.query_result.size()):
		print("Query results ", db.query_result[i]["baseName"], db.query_result[i]["primaryKey"])
		
# Called when the node enters the scene tree for the first time.
func _ready():
	db = SQLite.new()
	db.path = db_name
	getItemsByID(3)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
