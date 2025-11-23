#PLAYER CHARACTER TEMPLATE:
#	Template for holding loaded/current character 

extends Resource

class_name playerCharacterTemplate

const Capability_Source := preload("res://globalScripts/Char_Capability.gd")
var source_backend_capabilities = ["AG","APP", "CO","QU","MD","ST","CH","EM","IN","ME","MX","PR","RE","SD"]
var player_capabilities = []

	
func populate_default_character() -> void:
	for ability in source_backend_capabilities:
		var current = Capability_Source.new()
		current.name = ability
		player_capabilities.append(current)
	for specials in ["Health","Defense","Vision"]:
		var current = Capability_Source.new()
		current.name = specials
		player_capabilities.append(current)
	
func set_health () -> void: 
	var health_calc = 0
	for x in player_capabilities:
		if x.name == "CO":
			health_calc = health_calc + int(x.score) + int(x.modifier)
	for x in player_capabilities:
		if x.name == "Health":
			x.score = health_calc

func set_defense () -> void: 
	var def_calc = 0
	for x in player_capabilities:
		if x.defend:
			def_calc = def_calc + int(x.score) + int(x.modifier)
	for x in player_capabilities:
		if x.name == "Defense":
			x.score = def_calc
	
#DKM TEMP: these outputs will likely need to be expanded
#For output only:
#Defaulting to OpenD6, these can be updated via the GSP_Lookups and
#	Settings. In other settings, output B will often not be used.
var output_extras = ["Name","Profession","Quote"]
var output_labels = ["Agility","Coordination","Physique","Charisma","Intellect","Acumen"]
var output_scores_A = [0,0,0,0,0,0]
var output_A_label = "D"
var is_output_B = true
var output_B_label = "+"
var output_scores_B = [0,0,0,0,0,0]


var pcText = ""
 
var name = ""
var profession = "NA"
var quote = "..."


#Simple print from backend percentile stats; saved to template's PC text field.
func to_string_perc_PC() -> String:
	pcText = "NAME: " + str(name) + "\nPROF: " + str(profession) + "\n"
	for cap in player_capabilities:
		if (cap.name != null && cap.Game_toDisplay != false):
			pcText = pcText + str(cap.name) + ": " + str(int(cap.score) + int(cap.modifier)) + "\n"
	pcText = pcText + "QUOTE: " + str(quote)
	return pcText


func to_string_output_PC() -> String:
	pcText = "NAME: " + str(name) + "\nPROF: " + str(profession) + "\n"
	for cap in player_capabilities:
		if cap.Game_Name != null && cap.Game_Name != "NA":
			pcText = pcText + str(cap.Game_Name) + ": " + str(int(cap.Game_Value))
			if cap.Game_Extras != null:
				pcText = pcText + "D+" + str(cap.Game_Extras) + "\n"
			else:
				pcText = pcText +"\n"
				
	pcText = pcText + "QUOTE: " + str(quote)
	return pcText
	
func duplicate_core_capability (source_cap:Char_Capability) -> Char_Capability:
	var new_cap = Char_Capability.new()
	new_cap.name = source_cap.name
	new_cap.score = source_cap.score
	new_cap.attack = source_cap.attack
	new_cap.defend = source_cap.defend
	new_cap.use_range = source_cap.use_range
	new_cap.duration = source_cap.duration
	new_cap.impact_target = source_cap.impact_target
	new_cap.impact_amount = source_cap.impact_amount
	new_cap.uses_max = source_cap.uses_max
	new_cap.uses_current = source_cap.uses_current
	new_cap.recharge = source_cap.recharge
	new_cap.reload = source_cap.reload
	new_cap.modifier = source_cap.modifier
	return new_cap

func clear_character():
	player_capabilities.clear()

#Simple print the values in output; saved to template's PC text field.
#func to_string_output_PC() -> String:
#	pcText = "NAME: " + name + "\nPROF: " + profession + "\nQUOTE: " + quote + "\n"
#	var i = 0
#	for out_label in output_labels:
#		if output_scores_A.size() > i:
#			pcText = pcText + out_label + str(output_scores_A[i])
#		if is_output_B:
#			pcText = pcText + output_A_label
#			if(output_scores_B.size() > i && output_scores_B[i] != 0):
#				pcText = pcText + " " + output_B_label + str(output_scores_B[i])
#		pcText = pcText + "\n" 
#		i = i+1
#	return pcText
