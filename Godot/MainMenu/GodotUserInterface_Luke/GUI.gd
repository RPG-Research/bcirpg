extends MarginContainer

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://DataStore/database"

func _ready():
	db = SQLite.new()
	db.path = db_name
	#commitDataToDB()
	readFromDB()
	getItemsByUserID(1)

func commitDataToDB():
	db.open_db()
	var tableName = "PlayerInfo"
	var dict : Dictionary = Dictionary()
	dict["Name"] = "This is a test user1"
	dict["Score"] = 6000
	db.insert_row(tableName,dict)
	print("Row Inserted")
	
func readFromDB():
	db.open_db()
	var tableName = "PlayerInfo"
	db.query("select * from " + tableName + ";")
	for i in range(0,db.query_result.size()):
		print("Query results ", db.query_result[i]["Name"], db.query_result[i])

func getItemsByUserID(id):
	db.open_db()
	
	#To Do, we should probably make this more generic, so it can query differnt tables
	
	db.query("select playerinfo.name as pname, ItemIventory.name as iname from playerinfo left join ItemIventory on playerinfo.ID = ItemIventory.PlayerID where playerinfo.id = " + str(id))
	for i in range(0, db.query_result.size()):
		print("Query results ", db.query_result[i]["pname"], db.query_result[i]["iname"])
	return db.query_result
