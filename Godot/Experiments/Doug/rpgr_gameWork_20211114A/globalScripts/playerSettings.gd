#***PLAYER SETTINGS: a singleton to hold settings in-game. Currently for test
#	purposes, initializes a playerSettingsTemplate class, and attempts to
#	load in a saved player settings file. This then updates the singleton.

extends Node
 
var settings_file = "user://testPlayerSettings.sav"
var playerSettingsSingleton = PlayerSettingsTemplate.new()

func _ready() -> void:
	load_settings_file()

#Using JSON: 
#DKM TEMP: manual JSON parsing is most certainly not the way to go -- temp testing these 
#	are saved and loaded correctly. 
func load_settings_file():
		var file = File.new()
		file.open(settings_file, file.READ)
		var text = file.get_as_text()
		var parsedText = parse_json(text)
		if(parsedText != null):
			print("Input name loaded as: " + parsedText.playerSettingsTemplate.inputName)
			playerSettingsSingleton.inputName = parsedText.playerSettingsTemplate.inputName
			playerSettingsSingleton.riskFactor = parsedText.playerSettingsTemplate.riskFactor
		else:
			print("No previously existing player settings file found")
			
#DKM TEMP:			
#****THIS LOADS a string successfully, but not objects
#func _loadSettings() -> void:	
		#DKM TEMP: we cannot hard code this here and allow user access on But_SaveS UI
#	var settings_file = "user://testSettings"
#	var file = File.new()
#	if file.file_exists(settings_file):
#		file.open(settings_file, File.READ)
#		playerSettingsSingleton.inputName = file.get_var()
#		file.close()
#		print("name found as: " + playerSettingsSingleton.inputName)
