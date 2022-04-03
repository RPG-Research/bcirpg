extends Control


onready var NameVar = get_node('Panel/Label/VBoxContainer/HBoxDisplayName/LineEdit')

onready var NRiskVar = get_node('Panel/Label/VBoxContainer/HBoxRiskFactor/LineEdit')

onready var FontVar = get_node('Panel/Label2/VBoxContainer/HSlider2')

onready var BrightnessVar = get_node('Panel/Label2/VBoxContainer/HSlider3')

onready var VolumeVar = get_node('Panel/Label3/VBoxContainer/HSlider2')

onready var ConsoleCommandVar = get_node('Panel/Label3/VBoxContainer/HBoxDevConsole/CheckBox')

onready var ClosedCaptionsVar = get_node('Panel/Label3/VBoxContainer/HBoxClosedCaptions/CheckBox')

onready var saveButton = get_node("Panel/SaveButton")

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
	iniFile.set_value("player_preferences", "player_name", NameVar.text)
	iniFile.set_value("player_preferences", "risk_threshold", NRiskVar.text)
	iniFile.set_value("visual_controls", "font_size", FontVar.value)
	iniFile.set_value("visual_controls", "brightness", BrightnessVar.value)
	iniFile.set_value("general_settings", "volume", VolumeVar.value)
	iniFile.set_value("general_settings", "closed_captions", ClosedCaptionsVar.is_pressed())
	iniFile.set_value("general_settings", "dev_console", ConsoleCommandVar.is_pressed())	
	iniFile.save("user://PlayerPreferences.cfg")

func loadFile():
	pass
	
func _process(delta):
	if saveButton.pressed == true:
		saveFile()
		print('saveFileRan')
		
func _ready():
	pass
