extends Node


var bIsDarkThemeOn = false
var settingsFile = "user://settings.cfg"
var playerSettingsSingleton = PlayerSettingsTemplate.new()




func make_settings_file():
	var config = ConfigFile.new()
	
	config.set_value("Player", "InputName", "Default Name")
	config.set_value("Player", "riskFactor", 0)
	config.set_value("Player", "brightness", 3)
	config.set_value("Player", "fontSize", 11)
	config.set_value("Player", "volume", 6)
	var bClosedCaptions = config.set_value("player", "bClosedCaptions")
	var bDevConsole = config.set_value("Player", "bDevConsole")
	var bVirtualKeyboard = config.set_value("Player", "bVirtualKeyboard", false)
	var preferredTheme = config.set_value("Player", "preferredTheme", PlayerSettingsTemplate.ThemeChoice.LIGHTHIGHCONTRAST)
	var visualKeyboardLayout = config.set_value("Player", "visualKeyboardLayout", PlayerSettingsTemplate.KeyboardLayout.QWERTY)
	
	config.save("user://settings.cfg")



#Config/ini:
func load_settings_file():
	var config = ConfigFile.new()
	# Load data from a file.
	var err = config.load(settingsFile)
	# If the file didn't load, ignore it.
	if err != OK:
		return
	for player in config.get_sections():
		var inputName = config.get_value(player, "InputSettings")
		var riskFactor = config.get_value(player, "riskFactor")
		var brightness = config.get_value(player, "brightness")
		var fontSize = config.get_value(player, "fontSize")
		var volume = config.get_value(player, "volume")
		var bClosedCaptions = config.get_value(player, "bClosedCaptions")
		var bDevConsole = config.get_value(player, "bDevConsole")
		var bVirtualKeyboard = config.get_value(player, "bVirtualKeyboard")
		var preferredTheme = config.get_value(player, "preferredTheme")
		var visualKeyboardLayout = config.get_value(player, "visualKeyboardLayout")
		
		print("Input name loaded as: " + inputName)
		
		playerSettingsSingleton.inputName = inputName
		playerSettingsSingleton.riskFactor = riskFactor




func EnableGlobalThemes(bDark):
	if (bDark == true):
		controlNode.theme=load("res://assets/ui_controlNode_dark_theme.tres")
		
	if (bDark == false):
		controlNode.theme=load("res://assets/ui_controlNode_light_theme.tres")

func _ready():
	pass # Replace with function body.
