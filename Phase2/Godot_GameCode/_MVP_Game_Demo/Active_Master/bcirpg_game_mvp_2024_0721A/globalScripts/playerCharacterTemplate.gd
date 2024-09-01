#PLAYER CHARACTER TEMPLATE:
#	Template for holding loaded/current character 

extends Resource

class_name playerCharacterTemplate

#DKM TEMP: these outputs will likely need to be expanded
#For output only:
#Defaulting to OpenD6, these can be updated via the GSP_Lookups and
#	Settings. In other settings, output B will often not be used.
var output_labels = ["Agility","Coordination","Physique","Charisma","Intellect","Acumen"]
var output_scores_A = [2,2,2,4,4,4]
var output_A_label = "D"
var is_output_B = true
var output_B_label = "+"
var output_scores_B = [1,0,2,0,0,0]


var pcText = ""
 
var name = ""
var profession = "NA"
var weapon = "None"
var armor = "None"
var quote = "..."

#Physical stats (BCI-RPG Backend Percentile System):
var AG = 0
var APP = 0
var CO = 0
var QU = 0
var MD = 0
var ST = 0
#Non-Physical stats (BCI-RPG Backend Percentile System):
var CH = 0
var EM = 0
var IN = 0
var ME = 0
var MX = 0
var PR = 0
var RE = 0
var SD = 0


#Simple print from backend percentile stats; saved to template's PC text field.
func print_percentile_PC() -> void:
	pcText = "NAME: " + name + "\nPROF: " + profession + "\nPHYSICAL ABILITIES:\n" \
	+ "	Agility: " + str(AG) + "\n" \
	+ "	Appearance: " + str(APP) + "\n" \
	+ "	Constitution: " + str(CO) + "\n" \
	+ "	Quickness: " + str(QU) + "\n" \
	+ "	Manual Dexterity: " + str(MD) + "\n" \
	+ "	Strength: " + str(ST) + "\n" \
	+ "Non-Physical Abilities:\n"\
	+ "	TBD\n"\
	+ "QUOTE: " + quote

#Simple print the values in output; saved to template's PC text field.
func print_output_PC() -> void:
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
	pcText = pcText + "Weapon: " + weapon + "\n" 
	pcText = pcText + "Armor: " + armor + "\n" 
