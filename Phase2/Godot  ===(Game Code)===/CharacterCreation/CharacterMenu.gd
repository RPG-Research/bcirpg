extends Node2D

var Gender = -1
var Name = ""
var Profession = ""

func _ready():
	add_items()

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
	
	if (Gender != -1 and Name and Profession):
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
	
func add_items():
	$Profession/DropDown.add_item("Hunter")
	$Profession/DropDown.add_item("Witch")
	$Profession/DropDown.add_item("Farmer")
	$Profession/DropDown.add_item("Magician")


func _on_DropDown_item_selected(index):
	Profession = $Profession/DropDown.get_item_text(index)


func _on_Name_text_changed(new_text):
	Name = $Name.text
