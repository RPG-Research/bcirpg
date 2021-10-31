#Script for settings save button
#Tool lets you any code in editor, such as plugins
tool
extends Button

#Creates param usable in the UI; and the params next to export make it string and file browser
export(String, FILE) var next_scene_path: = ""

#Button response: save settings and move on. 
func _on_But_NewGame_button_up():
	var inputName = get_node("../../VBoxContainer/HBoxContainer/input_name")
	var inputRisk = get_node("../../VBoxContainer/HBoxContainer2/input_risk")
	_saveSettings(inputName.text, inputRisk.text)
	get_tree().change_scene(next_scene_path)


#HELPER FUNCTIONS:
func _get_configuration_warning() -> String:
		return "next_scene_path must be set for this button to work" if next_scene_path == "" else ""
		
		
func _saveSettings(inputSettings : String, riskFactor : String) -> void:	
	var player_settings = get_node("/root/PlayerSettings")
	player_settings.playerSettingsSingleton.inputName = inputSettings
	player_settings.playerSettingsSingleton.riskFactor = riskFactor	
	#Temp:
	var temp_manual_JSON = {
		"playerSettingsTemplate": {
			"inputName": inputSettings,
			"riskFactor": riskFactor
		}
	}
	
	#Save to file (JSON for now)
	var settings_file = "user://testPlayerSettings.sav"
	var file = File.new()
	if file.open(settings_file, File.WRITE) != 0:
		print("Cannot write temporary file to: " + settings_file)
	else:
		file.store_line(to_json(temp_manual_JSON))
		file.close()

		
#****This save Settings functions as designed; but modified to work with alternate approach of loading
#func _saveSettings(inputSettings : String, riskFactor : String) -> void:	
		#Debugging:
#		print("Input name: " + inputSettings + "; and risk factor set to : " + riskFactor)
#		var player_settings = get_node("/root/PlayerSettings")
#		player_settings.playerSettingsSingleton.inputName = inputSettings
#		player_settings.playerSettingsSingleton.riskFactor = riskFactor
		
		#Save to file (for now)
#		if settings_save_file_name == "":
#			settings_save_file_name = "settings.save"
#		var settings_file = "user://" + settings_save_file_name
#		var file = File.new()
#		file.open(settings_file, File.WRITE)
#		file.store_var(player_settings.playerSettingsSingleton.inputName)
		#DKM TEMP: To save object; removed for testing
		#file.store_var(player_settings.playerSettingsSingleton, true)
#		file.close()



