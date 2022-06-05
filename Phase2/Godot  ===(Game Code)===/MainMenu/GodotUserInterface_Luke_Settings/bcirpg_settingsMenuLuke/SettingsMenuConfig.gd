extends Control


onready var keyboardContents = ["Qwerty", "Dvorak", "Alphabetical"]

onready var themeContents = ["White and Black", "Black and White"]

onready var saveObject = get_node('/root/GlobalSaveInstance') 

onready var NameVar = get_node('Panel/HBoxContainer/VBoxContainer2/Label/VBoxContainer/LineEdit')

onready var NRiskVar = get_node('Panel/HBoxContainer/VboxContainer2/Label/VBoxContainer/VBoxContainer/RiskSlider')

onready var FontVar = get_node("Panel/HBoxContainer/VBoxContainer/Label2/VBoxContainer/HSlider2")

onready var BrightnessVar = get_node('Panel/HBoxContainer/VBoxContainer/Label2/VBoxContainer/HSlider3')

onready var VolumeVar = get_node("Panel/HBoxContainer/Label3/VBoxContainer/HSlider2")

onready var ConsoleCommandVar = get_node('Panel/HBoxContainer/VBoxContainer3//Label3/VBoxContainer/HBoxDevConsole/CheckBox')

onready var ClosedCaptionsVar = get_node('Panel/HBoxContainer/VBoxContainer3/Label3/VBoxContainer/HBoxClosedCaptions/CheckBox')

onready var saveButton = get_node("Panel/HBoxContainer/VBoxContainer3/Label3/VBoxContainer/SaveButton")

onready var bKeyboardEnabled = get_node("Panel/HBoxContainer/VBoxContainer3//Label3/VBoxContainer/HBoxVirtualKeyboardEnabled/CheckBox")

onready var keyboardLayoutList = get_node('Panel/HBoxContainer/VBoxContainer3/Label3/VBoxContainer/ItemList') 

onready var themeChoiceList = get_node('Panel/HBoxContainer/VBoxContainer3/Label3/VBoxContainer/ItemList2')

var iniFile = ConfigFile.new()

func saveToInstance():

	#Save to Singleton, so saveFile does not need to be constantly read
	saveObject.settingsInstance.inputName = NameVar.text
	saveObject.settingsInstance.riskFactor = NRiskVar.value
	saveObject.settingsInstance.fontSize = FontVar.Value
	saveObject.settingsInstance.volume = VolumeVar.value
	saveObject.settingsInstance.bClosedCaptions = ClosedCaptionsVar.is_pressed()
	saveObject.settingsInstance.bdevConsole = ConsoleCommandVar.is_pressed()
	saveObject.settingsInstance.bVirtualKeyboard = bKeyboardEnabled.is_pressed()
	
#	saveObject.settingsInstance.visualKeyboardLayout =
#	saveobject.settingsInstance.themeChoice = 
	
	
	## TO DO

	## Make Theme and Keyboard Options Tie To Their Enunms

	#Add Theme and Keyboard Selections to singeton

	print(saveObject)
	

func saveFile():
	iniFile.set_value("player_preferences", "player_name", NameVar.text)
	iniFile.set_value("player_preferences", "risk_threshold", NRiskVar.value)
	iniFile.set_value("visual_controls", "font_size", FontVar.value)
	iniFile.set_value("visual_controls", "brightness", BrightnessVar.value)
	
	iniFile.set_value("general_settings", "volume", VolumeVar.value)
	iniFile.set_value("general_settings", "closed_captions", ClosedCaptionsVar.is_pressed())
	iniFile.set_value("general_settings", "dev_console", ConsoleCommandVar.is_pressed())	
	
	
	print(keyboardLayoutList.get_selected_items())
	
	var savedKeyboardItems = keyboardLayoutList.get_selected_items() 

	var keyboardSelection = savedKeyboardItems[0]
	
	var savedThemeItems = keyboardLayoutList.get_selected_items() 

	var themeSelection = savedThemeItems[0]
	
	print(typeof(keyboardSelection))
	
	iniFile.set_value("virtual_keyboard", "keyboard_layout", keyboardSelection)
	
	iniFile.set_value("theme", "theme_selection", themeSelection)
	
	iniFile.save("user://PlayerPreferences.cfg")

func loadFile():
	pass
	
func _process(delta):
	if saveButton.pressed == true:
		
		# Save to the template instance
		saveToInstance()
		
		saveFile()
		print('saveFileRan')
		
func _ready():
	
	for i in range(3):
		keyboardLayoutList.add_item(keyboardContents[i],null,true)
	
	keyboardLayoutList.select(0,true)
	
	for i in range(2):
		themeChoiceList.add_item(themeContents[i],null,true)
	
	keyboardLayoutList.select(0,true)
	
	themeChoiceList.select(0,true)
