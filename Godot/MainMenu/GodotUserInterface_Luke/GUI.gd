extends MarginContainer


onready var currentSelection_Start = get_node("HBoxContainer/VBoxContainer/MenuOptions/StartGame")
onready var currentSelection_DieTest = get_node("HBoxContainer/VBoxContainer/MenuOptions/DieTest")
onready var currentSelection_LoadGame = get_node("HBoxContainer/VBoxContainer/MenuOptions/LoadGame")
onready var currentSelection_HostAndJoinGame = get_node("HBoxContainer/VBoxContainer/MenuOptions/HostAndJoinGame")
onready var currentSelection_PlayerSettings = get_node("HBoxContainer/VBoxContainer/MenuOptions/PlayerSettings")

var currentSelectionIndex = 0;
var currentIndexObject = currentSelection_Start;

func _ready():
	SetMenuSelections(currentSelectionIndex)
	
func _process(delta):	
	if Input.is_action_just_pressed("ui_down"):
		currentSelectionIndex +=1;
		if(currentSelectionIndex == 5):
			currentSelectionIndex = 0
		SetMenuSelections(currentSelectionIndex)

		
func SetMenuSelections(CurrentSelection):
	currentSelection_Start.set_uppercase(false)
	currentSelection_DieTest.set_uppercase(false)
	currentSelection_LoadGame.set_uppercase(false)
	currentSelection_HostAndJoinGame.set_uppercase(false)
	currentSelection_PlayerSettings.set_uppercase(false)
	
	var index = CurrentSelection
	
	match index:
		0:
			currentSelection_PlayerSettings.set("custom_colors/default_color", Color(1,1,1,1))
			currentSelection_Start.set_uppercase(true)
			currentSelection_Start.set("custom_colors/default_color", Color(0,0,0,1))	
		1:
			currentSelection_Start.set("custom_colors/default_color", Color(1,1,1,1))
			currentSelection_DieTest.set_uppercase(true)
			currentSelection_DieTest.set("custom_colors/default_color", Color(0,0,0,1))
		
		2:
			currentSelection_DieTest.set("custom_colors/default_color", Color(1,1,1,1))
			currentSelection_LoadGame.set_uppercase(true)
			currentSelection_LoadGame.set("custom_colors/default_color", Color(0,0,0,1))
		3:
			currentSelection_LoadGame.set("custom_colors/default_color", Color(1,1,1,1))
			currentSelection_HostAndJoinGame.set_uppercase(true)
			currentSelection_HostAndJoinGame.set("custom_colors/default_color", Color(0,0,0,1))
		4: 
			currentSelection_HostAndJoinGame.set("custom_colors/default_color", Color(1,1,1,1))
			currentSelection_PlayerSettings.set_uppercase(true)
			currentSelection_PlayerSettings.set("custom_colors/default_color", Color(0,0,0,1))
