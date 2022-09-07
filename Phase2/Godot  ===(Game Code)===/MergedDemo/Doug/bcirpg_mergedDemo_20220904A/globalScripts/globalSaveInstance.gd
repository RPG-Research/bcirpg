extends Node

# Declare new settings template object
var settingsInstance =  PlayerSettingsTemplate.new()
var settings_file = "user://PlayerPreferences.cfg"

func _ready() -> void:
	load_settings_file() 
	
	#Config/ini:
func load_settings_file():
	var config = ConfigFile.new()
	# Load data from a file.
	var err = config.load(settings_file)
	# If the file didn't load, ignore it.
	if err != OK:
		return
	#Preferences:
	settingsInstance.inputName = config.get_value("player_preferences", "player_name")
	settingsInstance.riskFactor = config.get_value("player_preferences", "risk_threshold")		
	#Controls:
	settingsInstance.fontSize = config.get_value("visual_controls", "font_size")
	settingsInstance.brightness = config.get_value("visual_controls", "brightness")	
	#General Settings:
	settingsInstance.volume = config.get_value("general_settings", "volume")
	settingsInstance.bClosedCaptions = config.get_value("general_settings", "closed_captions")	
	settingsInstance.bdevConsole = config.get_value("general_settings", "dev_console")				
	#Keyboard:
	settingsInstance.visualKeyboardLayout = config.get_value("virtual_keyboard", "keyboard_layout")	
	#Theme:
	settingsInstance.themeChoiceInt = config.get_value("theme", "theme_selection")	
	
	load_themeFile()
	
	#DKM TEMP: working
	print("Input name loaded as: " + str(settingsInstance.inputName))
	print("Theme loaded as: " + str(settingsInstance.themeFile))
	
func load_themeFile() -> void:
	#DKM TEMP: this shouldn't be hard-coded:
	if(settingsInstance.themeChoiceInt == 1):
		settingsInstance.themeFile = "res://assets/ui_controlNode_light_theme.tres"
	else:
		settingsInstance.themeFile = "res://assets/ui_controlNode_dark_theme.tres"
