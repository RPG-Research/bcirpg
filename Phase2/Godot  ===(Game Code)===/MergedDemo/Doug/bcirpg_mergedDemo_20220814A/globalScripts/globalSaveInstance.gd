extends Node

# Declare new settings template object
var settingsInstance =  PlayerSettingsTemplate.new()
var settings_file = "user://PlayerPreferences.cfg"

# Called when the node enters the scene tree for the first time.
func _ready():
	load_settings_file() 
	
	#Config/ini:
func load_settings_file():
	var config = ConfigFile.new()
	# Load data from a file.
	var err = config.load(settings_file)
	# If the file didn't load, ignore it.
	if err != OK:
		return
	settingsInstance.inputName = config.get_value("player_preferences", "player_name")
	settingsInstance.riskFactor = config.get_value("player_preferences", "risk_threshold")		

	#DKM TEMP: working
	print("Input name loaded as: " + str(settingsInstance.inputName))
	print("Risk loaded as: " + str(settingsInstance.riskFactor))
