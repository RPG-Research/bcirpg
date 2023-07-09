#PLAYER SETTINGS: 
#	Unique handler script for reading from file or saving to, using the 
#	playerSettingsTemplateSingleton object.

extends Node
 
#DKM TEMP: JSON:
#var settings_file = "user://testPlayerSettings.sav"

#DKM TEMP: TO DO: constant:
var settings_file = "user://settings.cfg"
var playerSettingsSingleton = PlayerSettingsTemplate.new()

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
	for player in config.get_sections():
		var inputName = config.get_value(player, "InputSettings")
		var riskFactor = config.get_value(player, "RiskFactor")
		
		print("Input name loaded as: " + inputName)
		
		playerSettingsSingleton.inputName = inputName
		playerSettingsSingleton.riskFactor = riskFactor

#Using JSON: 
#DKM TEMP: manual JSON parsing is most certainly not the way to go -- temp testing these 
#	are saved and loaded correctly. 
#func load_settings_file():
#		var file = File.new()
#		file.open(settings_file, file.READ)
#		var text = file.get_as_text()
#		var parsedText = parse_json(text)
#		if(parsedText != null):
#			print("Input name loaded as: " + parsedText.playerSettingsTemplate.inputName)
#			playerSettingsSingleton.inputName = parsedText.playerSettingsTemplate.inputName
#			playerSettingsSingleton.riskFactor = parsedText.playerSettingsTemplate.riskFactor
#		else:
#			print("No previously existing player settings file found")
#
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
