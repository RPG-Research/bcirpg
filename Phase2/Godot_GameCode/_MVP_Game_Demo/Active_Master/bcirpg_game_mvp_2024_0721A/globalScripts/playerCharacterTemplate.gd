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
var output_scores_A = [2,2,2,4,4,4]
var output_A_label = "D"
var is_output_B = true
var output_B_label = "+"
var output_scores_B = [1,0,2,0,0,0]


var pcText = ""
 
var name = ""
var profession = "NA"
var quote = "..."


#Simple print from backend percentile stats; saved to template's PC text field.
func to_string_perc_PC() -> String:
	pcText = "NAME: " + str(name) + "\nPROF: " + str(profession) + "\n"
	for cap in player_capabilities:
		pcText = pcText + str(cap.name) + ": " + str(int(cap.score) + int(cap.modifier)) + "\n"
	pcText = pcText + "QUOTE: " + str(quote)
	return pcText


#Simple print the values in output; saved to template's PC text field.
func to_string_output_PC() -> String:
	pcText = "NAME: " + name + "\nPROF: " + profession + "\nQUOTE: " + quote + "\n"
	var i = 0
	for out_label in output_labels:
		if output_scores_A.size() > i:
			pcText = pcText + out_label + ": " + str(output_scores_A[i])
		if is_output_B:
			pcText = pcText + output_A_label
			if(output_scores_B.size() > i && output_scores_B[i] != 0):
				pcText = pcText + " " + output_B_label + str(output_scores_B[i])
		pcText = pcText + "\n" 
		i = i+1
	return pcText
