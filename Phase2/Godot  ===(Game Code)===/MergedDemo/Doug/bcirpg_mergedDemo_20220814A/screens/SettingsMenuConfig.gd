extends Control


# https://stackoverflow.com/a/65774028 
# Be Sure to make these Vars as OnReadys; you can read up on it here.

# Items to Fill the dropdown Lists
onready var keyboardContents = ["Qwerty", "Dvorak", "Alphabetical"]

onready var themeContents = ["White on Black", "Black on White"]

onready var saveObject = get_node('/root/GlobalSaveInstance') 


#res://SettingsMenuControl.tscn

# Vars For UI Widgets
onready var NameVar = get_node('Panel/HBoxContainer/RootVboxPlayerPreferences/Label/VBoxPlayerPreferances/DisplayNameLineEdit')

onready var NRiskVar = get_node('Panel/HBoxContainer/RootVboxPlayerPreferences/Label/VBoxPlayerPreferances/VBoxRiskFactor/RiskSlider')

onready var FontVar = get_node("Panel/HBoxContainer/RootVboxVisualControls/VisualControlsLabel/VisualControlsVBox/FontSizeSlider")

onready var BrightnessVar = get_node('Panel/HBoxContainer/RootVboxVisualControls/VisualControlsLabel/VisualControlsVBox/BrightnessSlider')

onready var VolumeVar = get_node("Panel/HBoxContainer/RootVboxGeneralSettings/GeneralSettingsLabel/VBoxContainer/VolumeSlider")

onready var ClosedCaptionsVar = get_node('Panel/HBoxContainer/RootVboxGeneralSettings/GeneralSettingsLabel/VBoxContainer/HBoxClosedCaptions/ClosedCaptionsCheckBox')

onready var ConsoleCommandVar = get_node('Panel/HBoxContainer/RootVboxGeneralSettings/GeneralSettingsLabel/VBoxContainer/HBoxDevConsole/DevConsoleCheckbox')

onready var saveButton = get_node("Panel/HBoxBottomRow/SaveButton")

onready var bKeyboardEnabled = get_node("Panel/HBoxContainer/RootVboxVisualControls2/Label2/VBoxContainer/HBoxVirtualKeyboardEnabled/VisualKeyboardCheckBox")

onready var keyboardLayoutList = get_node('Panel/HBoxContainer/RootVboxVisualControls2/Label2/VBoxContainer/LayoutItemList') 

onready var themeChoiceList = get_node('Panel/HBoxContainer/RootVboxVisualControls2/Label2/VBoxContainer/ThemeItemList')


var iniFile = ConfigFile.new()

func saveToInstance():
	#Save to Singleton, so saveFile does not need to be constantly read
	saveObject.settingsInstance.inputName = NameVar.text
	saveObject.settingsInstance.riskFactor = NRiskVar.value
	saveObject.settingsInstance.fontSize = FontVar.value
	saveObject.settingsInstance.volume = VolumeVar.value
	saveObject.settingsInstance.bClosedCaptions = ClosedCaptionsVar.is_pressed()
	saveObject.settingsInstance.bdevConsole = ConsoleCommandVar.is_pressed()
	saveObject.settingsInstance.bVirtualKeyboard = bKeyboardEnabled.is_pressed()
	var savedKeyboardItems = keyboardLayoutList.get_selected_items() 
	var keyboardSelection = savedKeyboardItems[0]
	saveObject.settingsInstance.visualKeyboardLayout = keyboardSelection
	var savedThemeItems = themeChoiceList.get_selected_items() 
	var themeSelection = savedThemeItems[0]
	saveObject.settingsInstance.themeChoiceInt = themeSelection
	#Trigger re-load of the file name
	saveObject.load_settings_file()
	theme=load(saveObject.settingsInstance.themeFile)
	

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
	
	var savedThemeItems = themeChoiceList.get_selected_items() 

	var themeSelection = savedThemeItems[0]
	
	print(typeof(keyboardSelection))
	
	iniFile.set_value("virtual_keyboard", "keyboard_layout", keyboardSelection)
	
	iniFile.set_value("theme", "theme_selection", themeSelection)
	
	iniFile.save("user://PlayerPreferences.cfg")

#DKM TEMP: can this be done at singleton, initial load level instead of here?
func loadFile():
	pass
	
func _process(delta):
	if saveButton.pressed == true:
		if NameVar.text == "":
			print("Please input a name")
			
		if NameVar.text != "":
			# Save to the template instance
			saveToInstance()
			
			saveFile()
			print('saveFileRan')
		
func _ready():
	#Get the singleton's values for initial settings:
	NameVar.text = saveObject.settingsInstance.inputName
	NRiskVar.value = saveObject.settingsInstance.riskFactor
	FontVar.value = saveObject.settingsInstance.fontSize
	ClosedCaptionsVar.pressed = saveObject.settingsInstance.bClosedCaptions
	ConsoleCommandVar.pressed = saveObject.settingsInstance.bdevConsole
	bKeyboardEnabled.pressed = saveObject.settingsInstance.bVirtualKeyboard
	
	print(NameVar.get_path())
	
#	Init Keyboard Layout List
	for i in range(3):
		keyboardLayoutList.add_item(keyboardContents[i],null,true)
	
	keyboardLayoutList.select(0,true)
	
# 	Init Theme Choice List

	for i in range(2):
		themeChoiceList.add_item(themeContents[i],null,true)
	
	keyboardLayoutList.select(saveObject.settingsInstance.visualKeyboardLayout,true)
	
	themeChoiceList.select(saveObject.settingsInstance.themeChoiceInt,true)
	
	#Load selected theme:
	theme=load(saveObject.settingsInstance.themeFile)
