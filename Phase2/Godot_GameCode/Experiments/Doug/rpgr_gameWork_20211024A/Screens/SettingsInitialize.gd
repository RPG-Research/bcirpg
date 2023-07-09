extends Control

onready var psCurrentSettings = get_node("/root/PlayerSettings")


func _ready() -> void:
	var inputName = get_node("VBoxContainer/HBoxContainer/input_name")
	var inputRisk = get_node("VBoxContainer/HBoxContainer2/input_risk")
	inputName.text = psCurrentSettings.playerSettingsSingleton.inputName
	inputRisk.text = psCurrentSettings.playerSettingsSingleton.riskFactor
	

