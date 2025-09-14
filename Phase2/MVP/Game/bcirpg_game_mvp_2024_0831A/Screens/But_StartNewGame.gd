#BUT_CHANGESCENE:
#	Generic template script allowing GUI linking of scenes by button press.

tool
extends Button

#Creates param usable in the UI; and the params next to export make it string and file browser
export(String, FILE) var next_scene_path: = ""

onready var pSingleton = get_node("/root/PlayerCharacter").pc

var tempToggle = 0

func _on_But_NewGame_button_up():
	if(pSingleton.name.length() < 1):
		#print("GOT IT! Popup msg: " + $PopupDialog/WarnText.text)
		var alertPopup = get_node("../../PopupDialog")
		var alertPopupText = get_node("../../PopupDialog/WarnText")
		alertPopupText.text = "No player was loaded! Please save or load a character to begin game."
		alertPopup.popup_centered()
		return
	else:
		var _changeResponse = get_tree().change_scene(next_scene_path)


func _get_configuration_warning() -> String:
		return "next_scene_path must be set for this button to work" if next_scene_path == "" else ""

