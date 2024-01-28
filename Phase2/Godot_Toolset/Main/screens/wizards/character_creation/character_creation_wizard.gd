extends Control

onready var CharacterName = $"RootVBoxContainer/TopHBoxContainer/LeftVBoxContainer/VBoxContainer/CenterContainer/GridContainer/CharacterNameLineEdit" 

onready var Profession = $"RootVBoxContainer/TopHBoxContainer/LeftVBoxContainer/VBoxContainer/CenterContainer/GridContainer/ProfessionLineEdit" 

onready var Demeanor = $"RootVBoxContainer/TopHBoxContainer/LeftVBoxContainer/VBoxContainer/CenterContainer/GridContainer/DemeanorLineEdit" 

onready var Species = $"RootVBoxContainer/TopHBoxContainer/LeftVBoxContainer/VBoxContainer/CenterContainer/GridContainer/SpeciesLineEdit" 

onready var Culture = $"RootVBoxContainer/TopHBoxContainer/LeftVBoxContainer/VBoxContainer/CenterContainer/GridContainer/CultureLineEdit" 

onready var Faction = $"RootVBoxContainer/TopHBoxContainer/LeftVBoxContainer/VBoxContainer/CenterContainer/GridContainer/FactionLineEdit" 

onready var Description = $"RootVBoxContainer/TopHBoxContainer/LeftVBoxContainer/VBoxContainer/CenterContainer/GridContainer/DescriptionLineEdit" 

onready var HeightAndWeight = $"RootVBoxContainer/TopHBoxContainer/LeftVBoxContainer/VBoxContainer/CenterContainer/GridContainer/HWLineEdit" 

onready var Backstory = $"RootVBoxContainer/TopHBoxContainer/LeftVBoxContainer/VBoxContainer/CenterContainer/GridContainer/BackstoryLineEdit"

onready var Gender = $"RootVBoxContainer/TopHBoxContainer/LeftVBoxContainer/VBoxContainer/CenterContainer/GridContainer/GenderLineEdit"

onready var Equipment = $"RootVBoxContainer/TopHBoxContainer/LeftVBoxContainer/VBoxContainer/CenterContainer/GridContainer/EquipmentLineEdit"

onready var Charisma = $"RootVBoxContainer/TopHBoxContainer/LeftVBoxContainer/VBoxContainer/CenterContainer/GridContainer/CharismaLineEdit" 

onready var Dialog = $"RootVBoxContainer/TopHBoxContainer/LeftVBoxContainer/VBoxContainer/CenterContainer/GridContainer/DialogueLabel"
 
onready var Constitution = $"RootVBoxContainer/TopHBoxContainer/RightVBoxContainer/VBoxContainer/HBoxContainer/AttributesVboxContainer/CenterContainer/GridContainer/ConLineEdit"

onready var Agility = $"RootVBoxContainer/TopHBoxContainer/RightVBoxContainer/VBoxContainer/HBoxContainer/AttributesVboxContainer/CenterContainer/GridContainer/AgilityLineEdit" 

onready var SelfDisipline = $"RootVBoxContainer/TopHBoxContainer/RightVBoxContainer/VBoxContainer/HBoxContainer/AttributesVboxContainer/CenterContainer/GridContainer/SelfDisciplineLineEdit"

onready var Memory = $"RootVBoxContainer/TopHBoxContainer/RightVBoxContainer/VBoxContainer/HBoxContainer/AttributesVboxContainer/CenterContainer/GridContainer/MemoryLineEdit"

onready var Reasoning = $"RootVBoxContainer/TopHBoxContainer/RightVBoxContainer/VBoxContainer/HBoxContainer/AttributesVboxContainer/CenterContainer/GridContainer/ReasoningLineEdit"

onready var Strength = $"RootVBoxContainer/TopHBoxContainer/RightVBoxContainer/VBoxContainer/HBoxContainer/AttributesVboxContainer/CenterContainer/GridContainer/StrengthLineEdit"

onready var Quickness = $"RootVBoxContainer/TopHBoxContainer/RightVBoxContainer/VBoxContainer/HBoxContainer/AttributesVboxContainer/CenterContainer/GridContainer/QuicknessLineEdit"

onready var Presence = $"RootVBoxContainer/TopHBoxContainer/RightVBoxContainer/VBoxContainer/HBoxContainer/AttributesVboxContainer/CenterContainer/GridContainer/PresenceLineEdit"

onready var Intuition = $"RootVBoxContainer/TopHBoxContainer/RightVBoxContainer/VBoxContainer/HBoxContainer/AttributesVboxContainer/CenterContainer/GridContainer/IntuitionLineEdit"

onready var Empathy = $"RootVBoxContainer/TopHBoxContainer/RightVBoxContainer/VBoxContainer/HBoxContainer/AttributesVboxContainer/CenterContainer/GridContainer/EmpathyLineEdit"

onready var Appearence = $"RootVBoxContainer/TopHBoxContainer/RightVBoxContainer/VBoxContainer/HBoxContainer/AttributesVboxContainer/CenterContainer/GridContainer/AppearenceLineEdit"

onready var skill1 = $"RootVBoxContainer/TopHBoxContainer/RightVBoxContainer/VBoxContainer/HBoxContainer/SkillsVboxContainer/CenterContainer/GridContainer/SkillOptionButton"

onready var skill2 = $"RootVBoxContainer/TopHBoxContainer/RightVBoxContainer/VBoxContainer/HBoxContainer/SkillsVboxContainer/CenterContainer/GridContainer/SkillOptionButton2"

onready var skill3 = $"RootVBoxContainer/TopHBoxContainer/RightVBoxContainer/VBoxContainer/HBoxContainer/SkillsVboxContainer/CenterContainer/GridContainer/SkillOptionButton3"

onready var skill4 = $"RootVBoxContainer/TopHBoxContainer/RightVBoxContainer/VBoxContainer/HBoxContainer/SkillsVboxContainer/CenterContainer/GridContainer/SkillOptionButton4"

onready var skill5 = $"RootVBoxContainer/TopHBoxContainer/RightVBoxContainer/VBoxContainer/HBoxContainer/SkillsVboxContainer/CenterContainer/GridContainer/SkillOptionButton5"

onready var skill6 = $"RootVBoxContainer/TopHBoxContainer/RightVBoxContainer/VBoxContainer/HBoxContainer/SkillsVboxContainer/CenterContainer/GridContainer/SkillOptionButton6"

onready var skill7 = $"RootVBoxContainer/TopHBoxContainer/RightVBoxContainer/VBoxContainer/HBoxContainer/SkillsVboxContainer/CenterContainer/GridContainer/SkillOptionButton7"

onready var skill8 = $"RootVBoxContainer/TopHBoxContainer/RightVBoxContainer/VBoxContainer/HBoxContainer/SkillsVboxContainer/CenterContainer/GridContainer/SkillOptionButton8"

onready var skill9 = $"RootVBoxContainer/TopHBoxContainer/RightVBoxContainer/VBoxContainer/HBoxContainer/SkillsVboxContainer/CenterContainer/GridContainer/SkillOptionButton9"

onready var skill10 = $"RootVBoxContainer/TopHBoxContainer/RightVBoxContainer/VBoxContainer/HBoxContainer/SkillsVboxContainer/CenterContainer/GridContainer/SkillOptionButton10"

onready var special1 = $"RootVBoxContainer/TopHBoxContainer/RightVBoxContainer/VBoxContainer/HBoxContainer/SpecialAbilitiesVBoxContainer/CenterContainer/GridContainer/SBOptionButton"

onready var special2 = $"RootVBoxContainer/TopHBoxContainer/RightVBoxContainer/VBoxContainer/HBoxContainer/SpecialAbilitiesVBoxContainer/CenterContainer/GridContainer/SBOptionButton2"

onready var special3 = $"RootVBoxContainer/TopHBoxContainer/RightVBoxContainer/VBoxContainer/HBoxContainer/SpecialAbilitiesVBoxContainer/CenterContainer/GridContainer/SBOptionButton3"

onready var special4 = $"RootVBoxContainer/TopHBoxContainer/RightVBoxContainer/VBoxContainer/HBoxContainer/SpecialAbilitiesVBoxContainer/CenterContainer/GridContainer/SBOptionButton4"

onready var special5 = $"RootVBoxContainer/TopHBoxContainer/RightVBoxContainer/VBoxContainer/HBoxContainer/SpecialAbilitiesVBoxContainer/CenterContainer/GridContainer/SBOptionButton5"

onready var special6 = $"RootVBoxContainer/TopHBoxContainer/RightVBoxContainer/VBoxContainer/HBoxContainer/SpecialAbilitiesVBoxContainer/CenterContainer/GridContainer/SBOptionButton6"

onready var special7 = $"RootVBoxContainer/TopHBoxContainer/RightVBoxContainer/VBoxContainer/HBoxContainer/SpecialAbilitiesVBoxContainer/CenterContainer/GridContainer/SBOptionButton7"

onready var special8 = $"RootVBoxContainer/TopHBoxContainer/RightVBoxContainer/VBoxContainer/HBoxContainer/SpecialAbilitiesVBoxContainer/CenterContainer/GridContainer/SBOptionButton8"

onready var special9 = $"RootVBoxContainer/TopHBoxContainer/RightVBoxContainer/VBoxContainer/HBoxContainer/SpecialAbilitiesVBoxContainer/CenterContainer/GridContainer/SBOptionButton9"

	# 12/10/23 save the data to a xml file.

	# comments for future skill sets to use
	# ,skill1, skill2, skill3, skill4, skill5,
	# skill6, skill7, skill8, skill9, skill10, special1, special2, special3, special4, special5, special6,
	# special7, special8, special9

var headerData = ["CharacterName", "Profession", "Demeanor", "Species", "Culture", "Faction", "Description", "HeightAndWeight",
	"Backstory", "Gender", "Equipment", "Charisma", "Dialog", "Constitution", "Agility", "SelfDisipline", "Memory",
	  "Reasoning","Strength", "Quickness", "Presence", "Intuition", "Empathy", "Appearance", "skill1", "skill2", "skill3", "skill4",
	  "skill5", "skill6", "skill7", "skill8", "skill9", "skill10", "special1", "special2", "special3", "special4", "special5", "special6",
	  "special7", "special8", "special9"]
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


var file_path = "user://data.xml"  # Use 'user://' to save in the user data directory

func save_data_to_xml(data: Array, path: String) -> void:
	
	#save_user_data()
	
	
	var file = File.new()
	
	if file.open("user://data.xml", File.WRITE) == OK:
		file.store_line("<?xml version=\"1.0\" encoding=\"utf-8\"?>")
		file.store_line("<root>")
		
		for line_edit in data:
			var line_edit_text = line_edit.text
			file.store_line(line_edit_text)
			#file.store_line("\n")
		
		
		file.store_line("</root>")
		file.close()
		print("Data saved to XML file:", path)
	else:
		print("Error opening file for writing:", path)


func create_array_to_save() -> Array:
	var userData = [CharacterName, Profession, Demeanor, Species, Culture, Faction, Description, HeightAndWeight, 
	Backstory, Gender, Equipment, Charisma, Dialog, Constitution, Agility, SelfDisipline, Memory, Reasoning, 
	Strength, Quickness, Presence, Intuition, Empathy, Appearence]
	
	return userData

func _on_Button_pressed():
	save_data_to_xml(create_array_to_save(), file_path)



	
