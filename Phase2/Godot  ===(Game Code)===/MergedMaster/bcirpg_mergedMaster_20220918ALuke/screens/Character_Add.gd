#CHARACTER_ADD:
#	Script for adding a new character and both saving it to file and loading 
#		it into the character object
extends Control

onready var settings = get_node("/root/GlobalSaveInstance").settingsInstance



onready var nameVar = get_node("HBoxContainer/VBoxContainer/LabelName/LineEditName")
onready var profVar = get_node("HBoxContainer/VBoxContainer/LabelProf/LineEditProf")
onready var strengthVar = get_node("HBoxContainer/VBoxContainer/LabelStrength/LineEditStrength")
onready var intelVar = get_node("HBoxContainer/VBoxContainer/LabelIntellect/LineEditIntel")
onready var willpowerVar = get_node("HBoxContainer/VBoxContainer2/LabelWillpower/LineEditWill")
onready var charmVar = get_node("HBoxContainer/VBoxContainer2/LabelCharm/LineEditCharm")
onready var weaponVar = get_node("HBoxContainer/VBoxContainer2/LabelWeapon/LineEditWeapon")
onready var armorVar = get_node("HBoxContainer/VBoxContainer2/LabelArmor/LineEditArmor")
onready var quoteVar = get_node("HBoxContainer/VBoxContainer/LabelQuote/LineEditQuote")

func writeToCSV(nameV, profV, strengthV, intelV, willpowerV, charmV, weaponV, armorV, quoteV):
	pass


func _ready() -> void:
	theme=load(settings.themeFile)
	$Title/But_SaveChar.grab_focus()

func _on_But_SaveChar_pressed() -> void:
	$Title/FileDialog.popup()

#DKM TEMP: just text for now from text edit
func _on_FileDialog_file_selected(path: String) -> void:
	var pc = get_node("/root/PlayerCharacter")
	var newCharFile = File.new()
	newCharFile.open(path, 2)
	newCharFile.store_string($TextEdit.text)
	pc.playerCharacterSingleton.pcText = $TextEdit.text
