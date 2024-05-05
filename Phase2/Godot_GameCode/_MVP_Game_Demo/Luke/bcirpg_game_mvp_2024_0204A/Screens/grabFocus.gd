extends Control

#GRAB FOCUS: simple script for temp files to grab focus


onready var Network = get_node("/root/Network").pc


func _ready() -> void:
	$Title/But_ChangeScene.grab_focus()


var _player_name = ""

var _IP_address = ""

var _port = ""


#TODO, look into Todo function


func _on_CreateButton_pressed():
	if _player_name == "":
		return
	Network.create_server(_player_name)
#	_load_game()


func _on_ConnectButton_pressed():
	if _player_name == "":
		return
	Network.connect_to_server(_player_name)
#	_load_game()
