extends Control


onready var multiplayer_config_ui = $Multiplayer_Configure
onready var server_ip_address = $Multiplayer_Configure/Server_IP_Address
onready var device_ip_address = $CanvasLayer/Device_IP_Address



# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	
	device_ip_address.text = Network.ip_address

func _player_connected(id) -> void:
	print("Player " + str(id) + "connected")
	
func _player_disconnected(id) -> void:
	print("Player " + str(id) + "disconnected")

func _on_Create_Server_pressed():
	multiplayer.config_ui.hide()
	Network._create_server()

func _on_Join_Server_pressed():
	if server_ip_address.text != "":
		multiplayer_config_ui.hide()
		Network.ip_address = server_ip_address.text
		Network._join_server()
