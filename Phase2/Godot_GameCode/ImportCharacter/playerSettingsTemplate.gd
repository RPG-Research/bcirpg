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

var inputName: String = "none"
var riskFactor: int = 0
var brightness: int = 3
var fontSize: int = 11
var volume: int = 6
var bClosedCaptions: bool = true
var bdevConsole: bool = false
var bVirtualKeyboard: bool = false
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
