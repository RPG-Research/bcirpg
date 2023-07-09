extends Control


var playerCounter = 1
var player = load("res://Player.tscn")

onready var multiplayer_config_ui = $Multiplayer_Configure
#onready var server_ip_address = $Multiplayer_Configure/Server_IP_Address
onready var device_ip_address = $CanvasLayer/Device_IP_Address
onready var player_name = $Multiplayer_Configure/Player_Name
onready var room_name = $Multiplayer_Configure/Room_Name
onready var room_password = $Multiplayer_Configure/Room_Password
onready var room_ui = $Room_UI



# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	
	device_ip_address.text = Network.ip_address

func _player_connected(id) -> void:
	print("Player " + str(id) + "connected")
	Network._instance_player(id, "New Player")
	
func _player_disconnected(id) -> void:
	print("Player " + str(id) + "disconnected")
	
	if Players.has_node(str(id)):
		Players.get_node(str(id)).queue_free()

func _on_Create_Server_pressed():
	multiplayer_config_ui.hide()
	Network._create_server()
	Network._instance_player(get_tree().get_network_unique_id(), player_name.text)
	Network._set_server_info(room_name.text, room_password.text)
	$Room_UI/Room_Name.text = room_name.text
	room_ui.show()

#func _on_Join_Server_pressed():
#	if server_ip_address.text != "":
#		multiplayer_config_ui.hide()
#		Network.ip_address = server_ip_address.text
#		Network._join_server()

func _connected_to_server() -> void:
	yield(get_tree().create_timer(0.1), "timeout")
	Network._instance_player(get_tree().get_network_unique_id(), player_name.text)


