extends MarginContainer

onready var selection_Start = $HBoxContainer/VBoxContainer/MenuOptions/StartGame
onready var selection_DieTest = $HBoxContainer/VBoxContainer/MenuOptions/DieTest
onready var selection_LoadGame = $HBoxContainer/CenterContainer/MenuOptions/LoadGame
onready var selection_HostAndJoinGame = $HBoxContainer/VBoxContainer/MenuOptions/HostAndJoinGame
onready var selection_PlayerSettings =$HBoxContainer/VBoxContainer/MenuOptions/PlayerSettings

var currentSelectionIndex = 0;

func _ready():
	var TimeTest = OS.get_datetime()
	print(TimeTest)
	
func _process(delta):	
	if Input.is_action_just_pressed("ui_down"):
		currentSelectionIndex +=1;
		if(currentSelectionIndex == 5):
			currentSelectionIndex = 0
		SetMenuSelections(currentSelectionIndex)
		
func SetMenuSelections(CurrentSelection):
	selection_Start.set_uppercase(false)
	selection_DieTest.set_uppercase(false)
	selection_LoadGame.set_uppercase(false)
	selection_HostAndJoinGame.set_uppercase(false)
	selection_PlayerSettings.set_uppercase(false)
	
	var index = CurrentSelection
	
	match index:
		0:
			selection_Start.set_uppercase(true)
		1:
			selection_DieTest.set_uppercase(true)
		2: 
			selection_LoadGame.set_uppercase(true)
		3:
			selection_HostAndJoinGame.set_uppercase(true)
		4: 
			selection_PlayerSettings.set_uppercase(true)
		
