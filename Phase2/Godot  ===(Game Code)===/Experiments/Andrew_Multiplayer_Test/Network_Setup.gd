extends Control


#var playerCounter = 1
#var player = load("res://Player.tscn")
#
#onready var multiplayer_config_ui = $Multiplayer_Configure
#onready var server_ip_address = $Multiplayer_Configure/Server_IP_Address
#onready var device_ip_address = $CanvasLayer/Device_IP_Address
#
#
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	get_tree().connect("network_peer_connected", self, "_player_connected")
#	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
#	get_tree().connect("connected_to_server", self, "_connected_to_server")
#
#	device_ip_address.text = Network.ip_address
#
#func _player_connected(id) -> void:
#	print("Player " + str(id) + "connected")
#	instance_player(id)
#
#func _player_disconnected(id) -> void:
#	print("Player " + str(id) + "disconnected")
#
#	if Players.has_node(str(id)):
#		Players.get_node(str(id)).queue_free()
#
#func _on_Create_Server_pressed():
#	multiplayer_config_ui.hide()
#	Network._create_server()
#	instance_player(get_tree().get_network_unique_id())
#
#func _on_Join_Server_pressed():
#	if server_ip_address.text != "":
#		multiplayer_config_ui.hide()
#		Network.ip_address = server_ip_address.text
#		Network._join_server()
#
#func _connected_to_server() -> void:
#	yield(get_tree().create_timer(0.1), "timeout")
#	instance_player(get_tree().get_network_unique_id())
#
#func instance_player(id) -> void:
#	var player_instance = Global.instance_node(player, Players)
#	player_instance.name = str(id)
#	var player_name = "Player " + str(playerCounter)
#	player_instance._set_name(player_name)
#	player_instance._set_name_position(playerCounter)
#	player_instance.set_network_master(id)
#	playerCounter += 1


