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

func writeToCSV(nameV, profV, strengthV, intelV, willpowerV, charmV, weaponV, armorV, quoteV):
	var f = File.new()
	f.open("res://_userFiles/CharacterOutput.csv", File.WRITE)
	var ArrayStrings = [PoolStringArray()]
	
	f.store_csv_line(["Name", nameV])
	f.store_csv_line(["Profession", profV])
	f.store_csv_line(["Strength", strengthV])
	f.store_csv_line(["Intellegence", intelV])
	f.store_csv_line(["Willpower", willpowerV])
	f.store_csv_line(["Charm", charmV])
	f.store_csv_line(["Weapon", weaponV])
	f.store_csv_line(["Armor", armorV])
	f.store_csv_line(["Quote", quoteV])
	f.close()
	
	
func _process(delta):
	if SaveButton.pressed == true:
		$Title/FileDialog.popup()
				
		writeToCSV(nameVar.get_text(), profVar.get_text(), 
		strengthVar.get_text(), intelVar.get_text(), willpowerVar.get_text(), 
		charmVar.get_text(), weaponVar.get_text(), armorVar.get_text(), quoteVar.get_text())
		
func _ready() -> void:
	theme=load(settings.themeFile)
	
#DKM TEMP: just text for now from text edit
func _on_FileDialog_file_selected(path: String) -> void:
	var pc = get_node("/root/PlayerCharacter")
	var newCharFile = File.new()
	newCharFile.open(path, 2)
	newCharFile.store_string($TextEdit.text)
	pc.playerCharacterSingleton.pcText = $TextEdit.text
