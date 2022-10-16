#PLAYER CHARACTER TEMPLATE:
#	Template for holding loaded/current character 

extends Resource

class_name playerCharacterTemplate

var pcText = ""

#BCO-RPG SRIS system (percentile):
var viableCharStats = ["AG",
"APP",
"CO",
"QU",
"MD",
"ST",
"CH",
"EM",
"IN",
"ME",
"MX",
"PR",
"RE",
"SD"]

var agility = 0
var appearance = 0
var constitution = 0
var quickness = 0
var manual_dexterity = 0
var strength = 0
var chutzpah = 0
var empathy = 0
var intuition = 0 
var memory = 0 
var moxie = 0 
var presence = 0 
var reasoning = 0 
var self_discipline = 0 

func toString() -> String:
	return("pcText: " + str(pcText) + 
	"; Agility: " + str(agility) +
	"; Appearance: " + str(appearance) +
	"; Constitution: " + str(constitution) +
	"; Quickness: " + str(quickness) +
	"; Manual_dexterity: " + str(manual_dexterity) +
	"; Strength: " + str(strength) +
	"; Chutzpah: " + str(chutzpah) +
	"; Empathy: " + str(empathy) +
	"; Intuition: " + str(intuition) +
	"; Memory: " + str(memory) +
	"; Moxie: " + str(moxie) +
	"; Presence: " + str(presence) +
	"; Reasoning: " + str(reasoning) +
	"; Self_discipline: " + str(self_discipline)
	)
