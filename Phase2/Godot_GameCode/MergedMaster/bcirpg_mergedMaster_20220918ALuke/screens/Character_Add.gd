#CHARACTER_ADD:
#	Script for adding a new character and both saving it to file and loading 
#		it into the character object
extends Control

var originalPath = "res://_userFiles/Template.csv" 
var rows

onready var settings = get_node("/root/GlobalSaveInstance").settingsInstance

onready var SaveButton = get_node("HBoxContainer/VBoxContainer/SaveButton")
onready var nameVar = get_node("HBoxContainer/VBoxContainer/LabelName/LineEditName")
onready var profVar = get_node("HBoxContainer/VBoxContainer/LabelProfession/LineEditProf")
onready var strengthVar = get_node("HBoxContainer/VBoxContainer/LabelStrength/LineEditStrength")
onready var intelVar = get_node("HBoxContainer/VBoxContainer/LabelIntellect/LineEditIntel")
onready var willpowerVar = get_node("HBoxContainer/VBoxContainer2/LabelWillpower/LineEditWill")
onready var charmVar = get_node("HBoxContainer/VBoxContainer2/LabelCharm/LineEditCharm")
onready var weaponVar = get_node("HBoxContainer/VBoxContainer2/LabelWeapon/LineEditWeapon")
onready var armorVar = get_node("HBoxContainer/VBoxContainer2/LabelArmor/LineEditArmor")
onready var quoteVar = get_node("HBoxContainer/VBoxContainer2/LabelQuote/LineEditQuote")

func _process(delta):
	if SaveButton.pressed == true:
		$Title/FileDialog.popup()
				
func _ready() -> void:
	theme=load(settings.themeFile)
	
#DKM TEMP: just text for now from text edit
func _on_FileDialog_file_selected(path: String) -> void:
	var pc = get_node("/root/PlayerCharacter")
	
	var newCharFile = File.new()
	newCharFile.open(path, 2)
	var f = File.new()
	
	f.store_csv_line(["Name", nameVar.get_text()])
	f.store_csv_line(["Profession", profVar.get_text()])
	f.store_csv_line(["Strength", strengthVar.get_text()])
	f.store_csv_line(["Intellegence", intelVar.get_text()])
	f.store_csv_line(["Willpower", willpowerVar.get_text()])
	f.store_csv_line(["Charm", charmVar.get_text()])
	f.store_csv_line(["Weapon", weaponVar.get_text()])
	f.store_csv_line(["Armor", armorVar.get_text()])
	f.store_csv_line(["Quote", quoteVar.get_text()])
	f.close()
	
