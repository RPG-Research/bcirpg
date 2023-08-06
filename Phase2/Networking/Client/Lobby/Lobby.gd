extends Control

onready var player_name = $CenterContainer/VBoxContainer/GridContainer/NameLineEdit

onready var selected_IP = $CenterContainer/VBoxContainer/GridContainer/IPLineEdit

onready var selected_port = $CenterContainer/VBoxContainer/GridContainer/PortLineEdit

onready var waiting_room = $WaitingRoom

onready var ready_btn = $WaitingRoom/CenterContainer/VBoxContainer/ReadyButton


func _ready():
	player_name.text = Save.save_data["player_name"]
	selected_IP.text = Server.DEFAULT_IP
	selected_port.text = str(Server.DEFAULT_PORT)
	
func show_waiting_room():
	waiting_room.popup_centered()

func _on_ReadyBtn_pressed():
	ready_btn.disabled = true

func _on_NameLineEdit_text_changed(_new_text):
	Save.save_data["Player_name"] = player_name.text
	Save.save_game()

func _on_JoinButton_pressed():
	Server.selected_IP = selected_IP.text
	Server.selected_port = int(selected_port.text)
	Server._connect_to_server()
	show_waiting_room()

