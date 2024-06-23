#PLAYER CHARACTER TEMPLATE:
#	Template for holding loaded/current character 

extends Resource

class_name playerCharacterTemplate

#DKM TEMP: these outputs will need to be expanded
#For output only:
#Defaulting to OpenD6, these can be updated via the GSP_Lookups and
#	Settings. In other settings, output B will often not be used.
var output_labels = ["Agility","Coordination","Physique","Charisma","Intellect","Acumen"]
var output_scores_A = [2,2,2,4,4,4]
var output_scores_B = [0,0,0,0,0,0]


var pcText = ""
 
var name = ""
var profession = ""
var quote = ""

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


#Simple print for backend percentile system. 
func _print_PC():
	pcText="NAME: " + name + "\n" \
	+ "PROF: " + profession + "\n" \
	+ "Physical Abilities:\n" \
	+ "Agility: " + str(AG) + "\n" \
	+ "Appearance: " + str(APP) + "\n" \
	+ "Constitution: " + str(CO) + "\n" \
	+ "Quickness: " + str(QU) + "\n" \
	+ "Manual Dexterity: " + str(MD) + "\n" \
	+ "Strength: " + str(ST) + "\n" \
	+ "Non-Physical Abilities:\n" \
	+ "QUOTE: " + quote
