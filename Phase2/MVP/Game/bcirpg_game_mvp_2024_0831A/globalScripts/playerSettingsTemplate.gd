extends Node

class_name PlayerSettingsTemplate

#Actual in-game genre options are now taken from the library via the GAL scripts.
#enum Genre_Option {FANTASY}

# Declare Setting Options, to be used inside of the settings menu
var inputName = "none"
var riskFactor = 0
var brightness = 3
var fontSize = 3.0
var volume = 6
var bClosedCaptions = true
var bdevConsole = false
var bVirtualKeyboard = false
#var genre_selection = Genre_Option.FANTASY
var genre_options = ["FANTASY"]
var genre_selection = genre_options[0]
var game_options = ["OPEND6_FANTASY"]
var game_selection = game_options[0]

# Setting of 0 is Qwerty, Setting of 1 is Davorak, Setting of 2 is Alphabetical 
var visualKeyboardLayout = 0

var themeFile = "res://assets/Themes/ui_controlNode_dark_theme.tres"

func _ready():
	pass
	

