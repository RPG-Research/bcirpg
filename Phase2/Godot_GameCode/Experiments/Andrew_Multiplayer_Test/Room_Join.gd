extends Control

onready var multiplayer_config_ui = $Multiplayer_Configure
onready var server_ip_address = $Multiplayer_Configure/Server_IP_Address
onready var room_password = $Multiplayer_Configure/Room_Password
onready var player_name = $Multiplayer_Configure/Player_Name

func _on_Join_Server_pressed():
	if server_ip_address.text != "":
		multiplayer_config_ui.hide()
		Network.ip_address = server_ip_address.text
		Network._join_server()
		Network._instance_player(get_tree().get_network_unique_id(), player_name.text)
