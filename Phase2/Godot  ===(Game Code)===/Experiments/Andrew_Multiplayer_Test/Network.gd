extends Node

const DEFAULT_PORT = 28960
const MAX_CLIENTS = 6

var server = null
var client = null
var player_counter = 1
var player = load("res://Player.tscn")

var ip_address = ""
var room_name = ""
var room_password = ""

func _ready() -> void:
	ip_address = IP.get_local_addresses()[3]
	
	for ip in IP.get_local_addresses():
		if ip.begins_with("192.168.") and not ip.ends_with(".1"):
			ip_address = ip
			
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
func _create_server() -> void:
	server = NetworkedMultiplayerENet.new()
	server.create_server(DEFAULT_PORT, MAX_CLIENTS)
	get_tree().set_network_peer(server)	
	
func _join_server() -> void:
	client = NetworkedMultiplayerENet.new()
	client.create_client(ip_address, DEFAULT_PORT)
	get_tree().set_network_peer(client)

func _connected_to_server() -> void:
	print("Successfully connected to the server")
	
func _server_disconnected() -> void:
	print("Disconnected from the server")

func _set_server_info(name, password) -> void:
	room_name = name
	room_password = password

func _instance_player(id, name) -> void:
	var player_instance = Global._instance_node(player, Players)
	player_instance.name = str(id)
	player_instance._set_name(name)
	#Using player_counter to determine the positioning of the player's name on the screen
	#So that they aren't all overlapping
	player_instance._set_name_position(player_counter)
	player_instance.set_network_master(id)
	player_counter += 1
