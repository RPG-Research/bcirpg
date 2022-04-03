extends Control


var iniFile = ConfigFile.new()



func initFile():
	iniFile.set_value("player_preferences", "player_name", "Cliff")
	iniFile.set_value("player_preferences", "risk_threshold", 2)
	iniFile.set_value("visual_controls", "font_size", 3)
	iniFile.set_value("visual_controls", "brightness", 3)
	iniFile.set_value("general_settings", "volume", 3)
	iniFile.set_value("general_settings", "closed_captions", false)
	iniFile.set_value("general_settings", "dev_console", 3)	
	iniFile.save("user://PlayerPreferences.cfg")
func saveFile():
	iniFile.save("user://PlayerPreferences.cfg")

func loadFile():
	pass

func _ready():
	initFile()
