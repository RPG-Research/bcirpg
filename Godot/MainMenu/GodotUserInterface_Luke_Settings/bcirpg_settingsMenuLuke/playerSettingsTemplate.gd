extends Node

class_name PlayerSettingsTemplate

enum KeyboardLayout {
	QWERTY,
	ALPHABETICAL,
	DVORAK
}

enum ThemeChoice {
	DARKHIGHCONTRAST,
	LIGHTHIGHCONTRAST
}

var inputName = "none"
var riskFactor = 0
var brightness = 3
var fontSize = 11
var volume = 6
var bClosedCaptions = true
var bdevConsole = false
var bVirtualKeyboard = false
var visualKeyboardLayout = KeyboardLayout.QWERTY
var preferredTheme = ThemeChoice.DARKHIGHCONTRAST


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
