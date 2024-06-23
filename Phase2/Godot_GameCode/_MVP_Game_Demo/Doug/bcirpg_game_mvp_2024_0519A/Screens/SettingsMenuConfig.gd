extends Control


# https://stackoverflow.com/a/65774028 
# Be Sure to make these Vars as OnReadys; you can read up on it here.

#Allow us to link to the dropdowns on the UI:
export (NodePath) var genre_dropdown_path
export (NodePath) var game_dropdown_path

# Items to Fill the dropdown Lists
onready var keyboardContents = ["Qwerty", "Dvorak", "Alphabetical"]

onready var themeContents = ["White on Black", "Black on White"]

onready var saveObject = get_node('/root/GlobalSaveInstance') 

onready var genre_dropdown = get_node(genre_dropdown_path)
onready var game_dropdown = get_node(game_dropdown_path)

#res://SettingsMenuControl.tscn

#GAL is to hold instantiated Genre_Layer; needed for getting genre types
const Genre_Layer := preload("res://globalScripts/GAL_Lookups.gd")
onready var GAL = Genre_Layer.new()
#GSP is to hold instantiated GSP_Layer; needed for getting game types
const Game_Layer := preload("res://globalScripts/GSP_Lookups.gd")
onready var GSP = Game_Layer.new()

# Vars For UI Widgets
onready var NameVar = get_node('SettingsScroll/HBoxContainer/RootVboxPlayerPreferences/Label/VBoxPlayerPreferances/DisplayNameLineEdit')

onready var NRiskVar = get_node('SettingsScroll/HBoxContainer/RootVboxPlayerPreferences/Label/VBoxPlayerPreferances/VBoxRiskFactor/RiskSlider')

onready var FontVar = get_node("SettingsScroll/HBoxContainer/RootVboxVisualControls/VisualControlsLabel/VisualControlsVBox/FontSizeSlider")

onready var BrightnessVar = get_node('SettingsScroll/HBoxContainer/RootVboxVisualControls/VisualControlsLabel/VisualControlsVBox/BrightnessSlider')

onready var VolumeVar = get_node("SettingsScroll/HBoxContainer/RootVboxGeneralSettings/GeneralSettingsLabel/VBoxContainer/VolumeSlider")

onready var ClosedCaptionsVar = get_node('SettingsScroll/HBoxContainer/RootVboxGeneralSettings/GeneralSettingsLabel/VBoxContainer/HBoxClosedCaptions/ClosedCaptionsCheckBox')

onready var ConsoleCommandVar = get_node('SettingsScroll/HBoxContainer/RootVboxGeneralSettings/GeneralSettingsLabel/VBoxContainer/HBoxDevConsole/DevConsoleCheckbox')

onready var saveButton = get_node("HBoxBottomRow/SaveButton")

onready var bKeyboardEnabled = get_node("SettingsScroll/HBoxContainer/RootVboxVisualControls2/Label2/VBoxContainer/HBoxVirtualKeyboardEnabled/VisualKeyboardCheckBox")

onready var keyboardLayoutList = get_node('SettingsScroll/HBoxContainer/RootVboxVisualControls2/Label2/VBoxContainer/LayoutItemList') 

onready var themeChoiceList = get_node('SettingsScroll/HBoxContainer/RootVboxVisualControls2/Label2/VBoxContainer/ThemeItemList')


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
	saveObject.settingsInstance.genre_selection = saveObject.settingsInstance.genre_options[genre_dropdown.get_selected_id()]
	saveObject.settingsInstance.game_selection = saveObject.settingsInstance.game_options[game_dropdown.get_selected_id()]	
	var savedKeyboardItems = keyboardLayoutList.get_selected_items() 
	var keyboardSelection = savedKeyboardItems[0]
	saveObject.settingsInstance.visualKeyboardLayout = keyboardSelection
	var savedThemeItems = themeChoiceList.get_selected_items() 
	var themeSelection = savedThemeItems[0]
	saveObject.settingsInstance.themeChoiceInt = themeSelection
	#DKM TEMP: for web version, setting this to the singleton without requiring reprocess of file
	if(saveObject.settingsInstance.themeChoiceInt == 1):
		saveObject.settingsInstance.themeFile = "res://assets/ui_controlNode_light_theme.tres"
	else:
		saveObject.settingsInstance.themeFile = "res://assets/ui_controlNode_dark_theme.tres"
	#Load selected theme:
	theme=load(saveObject.settingsInstance.themeFile)
	#Trigger re-load of the file name
	#saveObject.load_settings_file()
	#theme=load(saveObject.settingsInstance.themeFile)
	

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
	
	iniFile.set_value("player_preferences", "genre_selection", saveObject.settingsInstance.genre_options[genre_dropdown.get_selected_id()])
	iniFile.set_value("player_preferences", "game_selection", saveObject.settingsInstance.game_options[game_dropdown.get_selected_id()])
	
	iniFile.save("res://_userFiles/PlayerPreferences.cfg")

#DKM TEMP: can this be done at singleton, initial load level instead of here?
func loadFile():
	pass
	
func _process(_delta):
	if saveButton.pressed == true:
		if NameVar.text == "":
			print("Please input a name")
			
		if NameVar.text != "":
			# Save to the template instance
			saveToInstance()
			
			saveFile()
			print('saveFileRan')
		
#FUNCTION: Add Genre Options (to dropdown)
#Params: None
#Returns: None
#Notes: Method to load genre options into our settings dropdown and our settings 
#	options. Fantasy exists by default, and hence is not added back to the settings.
func add_genre_options():
	var genreChoices = GAL.get_genre_options()
	for genre in genreChoices:
		if(genre != "FANTASY"):
			saveObject.settingsInstance.genre_options.append(genre)
		genre_dropdown.add_item(str(genre).to_lower())
		
#FUNCTION: Add Game System Options (to dropdown)
#Params: None
#Returns: None
#Notes: Method to load game system options into our settings dropdown and our settings 
#	options. OpenD6 exists by default, and hence is not added back to the settings.
func add_game_options():
	var gameChoices = GSP.get_game_options()
	for game in gameChoices:
		if(game != "OPEND6"):
			saveObject.settingsInstance.game_options.append(game)
		game_dropdown.add_item(str(game).to_lower())

		
func _ready():
	#Get our initial genre options for dropdown:
	add_genre_options()
	#Get our initial game system options for dropdown:
	add_game_options()	
	
	#Get the singleton's values for initial settings:
	NameVar.text = saveObject.settingsInstance.inputName
	NRiskVar.value = saveObject.settingsInstance.riskFactor
	FontVar.value = saveObject.settingsInstance.fontSize
	ClosedCaptionsVar.pressed = saveObject.settingsInstance.bClosedCaptions
	ConsoleCommandVar.pressed = saveObject.settingsInstance.bdevConsole
	bKeyboardEnabled.pressed = saveObject.settingsInstance.bVirtualKeyboard
	
	#genre_dropdown.select(saveObject.settingsInstance.genre_selection)
	genre_dropdown.select(saveObject.settingsInstance.genre_options.find(saveObject.settingsInstance.genre_selection))
	game_dropdown.select(saveObject.settingsInstance.game_options.find(saveObject.settingsInstance.game_selection))
		
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
