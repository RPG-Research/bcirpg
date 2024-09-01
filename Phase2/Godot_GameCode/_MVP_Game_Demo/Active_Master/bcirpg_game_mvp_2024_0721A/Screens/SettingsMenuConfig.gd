extends Control

# Export variables to link UI dropdowns
export (NodePath) var genre_dropdown_path
export (NodePath) var game_dropdown_path

# Predefined lists for keyboard layouts and theme options
onready var keyboardContents = ["Qwerty", "Dvorak", "Alphabetical"]
onready var themeContents = ["White on Black", "Black on White"]

# Reference to the global save instance
onready var saveObject = get_node('/root/GlobalSaveInstance')

# UI dropdown references
onready var genre_dropdown = get_node(genre_dropdown_path)
onready var game_dropdown = get_node(game_dropdown_path)

# Load genre and game system scripts
const Genre_Layer := preload("res://globalScripts/GAL_Lookups.gd")
onready var GAL = Genre_Layer.new()
const Game_Layer := preload("res://globalScripts/GSP_Lookups.gd")
onready var GSP = Game_Layer.new()

# UI Widget References
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

# Configuration file for saving/loading settings
var iniFile = ConfigFile.new()

# Function to save current settings to the global instance
func saveToInstance():
	# Save basic settings
	saveObject.settingsInstance.inputName = NameVar.text
	saveObject.settingsInstance.riskFactor = NRiskVar.value
	saveObject.settingsInstance.fontSize = FontVar.value
	saveObject.settingsInstance.volume = VolumeVar.value
	saveObject.settingsInstance.bClosedCaptions = ClosedCaptionsVar.is_pressed()
	saveObject.settingsInstance.bdevConsole = ConsoleCommandVar.is_pressed()
	saveObject.settingsInstance.bVirtualKeyboard = bKeyboardEnabled.is_pressed()
	
	# Save dropdown selections
	saveObject.settingsInstance.genre_selection = saveObject.settingsInstance.genre_options[genre_dropdown.get_selected_id()]
	saveObject.settingsInstance.game_selection = saveObject.settingsInstance.game_options[game_dropdown.get_selected_id()]    
	
	# Save keyboard layout selection 
	var savedKeyboardItems = keyboardLayoutList.get_selected_items()
	saveObject.settingsInstance.visualKeyboardLayout = savedKeyboardItems[0] if savedKeyboardItems.size() > 0 else 0
	
	# Save theme selection 
	var savedThemeItems = themeChoiceList.get_selected_items()
	saveObject.settingsInstance.themeChoiceInt = savedThemeItems[0] if savedThemeItems.size() > 0 else 0
	
	# Set theme file based on selection
	saveObject.settingsInstance.themeFile = "res://assets/ui_controlNode_light_theme.tres" if saveObject.settingsInstance.themeChoiceInt == 1 else "res://assets/ui_controlNode_dark_theme.tres"
	theme = load(saveObject.settingsInstance.themeFile)

# Function to save settings to configuration file
func saveFile():
	# Save player preferences
	iniFile.set_value("player_preferences", "player_name", NameVar.text)
	iniFile.set_value("player_preferences", "risk_threshold", NRiskVar.value)
	
	# Save visual controls
	iniFile.set_value("visual_controls", "font_size", FontVar.value)
	iniFile.set_value("visual_controls", "brightness", BrightnessVar.value)
	
	# Save general settings
	iniFile.set_value("general_settings", "volume", VolumeVar.value)
	iniFile.set_value("general_settings", "closed_captions", ClosedCaptionsVar.is_pressed())
	iniFile.set_value("general_settings", "dev_console", ConsoleCommandVar.is_pressed())    
	
	# Save keyboard layout 
	var savedKeyboardItems = keyboardLayoutList.get_selected_items()
	iniFile.set_value("virtual_keyboard", "keyboard_layout", savedKeyboardItems[0] if savedKeyboardItems.size() > 0 else 0)
	
	# Save theme selection 
	var savedThemeItems = themeChoiceList.get_selected_items()
	iniFile.set_value("theme", "theme_selection", savedThemeItems[0] if savedThemeItems.size() > 0 else 0)
	
	# Save genre and game selections
	iniFile.set_value("player_preferences", "genre_selection", saveObject.settingsInstance.genre_options[genre_dropdown.get_selected_id()])
	iniFile.set_value("player_preferences", "game_selection", saveObject.settingsInstance.game_options[game_dropdown.get_selected_id()])
	
	# Save the configuration file
	iniFile.save("res://_userFiles/PlayerPreferences.cfg")

# Function to load settings from configuration file
func loadFile():
	# Attempt to load the configuration file
	var err = iniFile.load("res://_userFiles/PlayerPreferences.cfg")
	if err != OK:
		print("Failed to load settings file. Using default values.")
		return

	# Load basic settings
	NameVar.text = iniFile.get_value("player_preferences", "player_name", "")
	NRiskVar.value = iniFile.get_value("player_preferences", "risk_threshold", 0)
	FontVar.value = iniFile.get_value("visual_controls", "font_size", 12)
	BrightnessVar.value = iniFile.get_value("visual_controls", "brightness", 1)
	VolumeVar.value = iniFile.get_value("general_settings", "volume", 1)
	ClosedCaptionsVar.pressed = iniFile.get_value("general_settings", "closed_captions", false)
	ConsoleCommandVar.pressed = iniFile.get_value("general_settings", "dev_console", false)
	bKeyboardEnabled.pressed = iniFile.get_value("virtual_keyboard", "keyboard_enabled", false)
	
	# Load keyboard layout 
	var keyboard_layout = iniFile.get_value("virtual_keyboard", "keyboard_layout", 0)
	if keyboard_layout < keyboardLayoutList.get_item_count():
		keyboardLayoutList.select(keyboard_layout)
	
	# Load theme selection 
	var theme_selection = iniFile.get_value("theme", "theme_selection", 0)
	if theme_selection < themeChoiceList.get_item_count():
		themeChoiceList.select(theme_selection)
	
	# Load genre selection
	var genre_selection = iniFile.get_value("player_preferences", "genre_selection", "FANTASY")
	var genre_index = saveObject.settingsInstance.genre_options.find(genre_selection)
	if genre_index != -1:
		genre_dropdown.select(genre_index)
	
	# Load game selection
	var game_selection = iniFile.get_value("player_preferences", "game_selection", "OPEND6")
	var game_index = saveObject.settingsInstance.game_options.find(game_selection)
	if game_index != -1:
		game_dropdown.select(game_index)
	
	# Update the global instance with loaded settings
	saveToInstance()

# Process function (called every frame)
func _process(_delta):
	if saveButton.pressed:
		if NameVar.text != "":
			saveToInstance()
			saveFile()
			print('saveFileRan')
		else:
			print("Please input a name")

# Function to add genre options to the dropdown
func add_genre_options():
	var genreChoices = GAL.get_genre_options()
	for genre in genreChoices:
		if genre != "FANTASY":
			saveObject.settingsInstance.genre_options.append(genre)
		genre_dropdown.add_item(str(genre).to_lower())

# Function to add game system options to the dropdown
func add_game_options():
	var gameChoices = GSP.get_game_options()
	for game in gameChoices:
		if game != "OPEND6":
			saveObject.settingsInstance.game_options.append(game)
		game_dropdown.add_item(str(game).to_lower())

# Ready function (called when the node enters the scene tree)
func _ready():
	# Add genre and game options to dropdowns
	add_genre_options()
	add_game_options()    
	
	# Populate keyboard layout list
	for i in range(3):
		keyboardLayoutList.add_item(keyboardContents[i], null, true)
	
	# Populate theme choice list
	for i in range(2):
		themeChoiceList.add_item(themeContents[i], null, true)
	
	# Load settings from file
	loadFile()
