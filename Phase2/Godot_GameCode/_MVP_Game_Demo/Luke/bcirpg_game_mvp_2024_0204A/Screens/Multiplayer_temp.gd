extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

onready var TextBoxName = get_node("Title/ConfigHBoxContainer/PlayerNameVboxContainer/PlayerLineEdit")

onready var TextBoxIP = get_node("Title/ConfigHBoxContainer/IPVboxContainer/IPLineEdit")

onready var TextBoxPort = get_node("Title/ConfigHBoxContainer/PortVboxContainer/PortLineEdit")



#	pass
var _player_name = ""

var _IP_address = ""

var _port = ""


#TODO, look into Todo function


func _on_CreateButton_pressed():
	
	_player_name = TextBoxName.text
		
		
	print("Test 1")
		
	if _player_name == "":
		return
	Network.create_server(_player_name)
	print("Test 2")
#	_load_game()


func _on_ConnectButton_pressed():
	
	_player_name = TextBoxName.text
	_IP_address = TextBoxIP.text
	_port = TextBoxPort.text
	
	
	if _player_name == "":
		return
	Network.connect_to_server(_player_name)
#	_load_game()
