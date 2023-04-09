extends Node2D

var Gender = -1
var Name = ""
var Profession = ""
var Tribe = ""

func _ready():
	profession_add_items()
	tribe_add_items()

func _process(delta):
	match GameGlobal.PlayerSelect:
		0:
			$PlayerSelect.play("Player0")
		1:
			$PlayerSelect.play("Player1")
		2:
			$PlayerSelect.play("Player2")
		3:
			$PlayerSelect.play("Player3")
		4:
			$PlayerSelect.play("Player4")
		5:
			$PlayerSelect.play("Player5")
	
	if fill_check():
		$Play.disabled = false
	
func _on_Right_pressed():
	if GameGlobal.PlayerSelect < 5:
		GameGlobal.PlayerSelect += 1

func _on_Left_pressed():
	if GameGlobal.PlayerSelect > 0:
		GameGlobal.PlayerSelect -= 1

func _on_Male_toggled(button_pressed):
	$Gender/Female.pressed = false
	Gender = 0
	
func _on_Female_toggled(button_pressed):
	$Gender/Male.pressed = false
	Gender = 1
	
func profession_add_items():
	$Profession/ProfessionDropDown.add_item("Hunter")
	$Profession/ProfessionDropDown.add_item("Witch")
	$Profession/ProfessionDropDown.add_item("Farmer")
	$Profession/ProfessionDropDown.add_item("Magician")
	
func tribe_add_items():
	$Profession/TribeDropDown.add_item("Hazuka")
	$Profession/TribeDropDown.add_item("Ahom")
	$Profession/TribeDropDown.add_item("Mising")
	$Profession/TribeDropDown.add_item("Kalita")
	
func fill_check():
	return Gender != -1 and Name and Profession and Tribe


func _on_DropDown_item_selected(index):
	Profession = $Profession/ProfessionDropDown.get_item_text(index)


func _on_Name_text_changed(new_text):
	Name = $Name.text


func _on_TribeDropDown_item_selected(index):
	Tribe = $Profession/TribeDropDown.get_item_text(index)


func _on_Import_pressed():
	$FileExplorer/FileDialog.popup()


func _on_FileDialog_file_selected(path):
	OS.shell_open(path)
