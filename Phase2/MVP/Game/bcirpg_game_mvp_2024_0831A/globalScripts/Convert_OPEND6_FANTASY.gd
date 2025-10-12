#Global script for running conversions specific to the OpenD6 game
#	system. This will be called by the GSP as needed.

class_name OpenD6_Fantasy_Converter

const ability_match = { "AG":"AGILITY|FUNC_1",
	"APP":"CHARISMA|FUNC_1",
	"CO":"PHYSIQUE|FUNC_1",
	"QU":"AGILITY|FUNC_1",
	"MD":"COORDINATION|FUNC_1",
	"ST":"PHYSIQUE|FUNC_1",
	"CH":"CHARISMA/ACUMEN|FUNC_2",
	"EM":"ACUMEN|FUNC_1",
	"IN":"ACUMEN|FUNC_1",
	"ME":"INTELLECT|FUNC_1",
	"MX":"ACUMEN|FUNC_1",
	"PR":"CHARISMA|FUNC_1",
	"RE":"INTELLECT|FUNC_1",
	"SD":"ACUMEN/PHYSIQUE|FUNC_2"
}

func get_ability_match()->Dictionary:
	return ability_match

func get_HW() -> String:
	return ("Hello Open D6 World!")

#DKM TEMP:
#Dice = 1+((Percentile #)/25), rounded down)
#Bonus = (Remainder of the division above)/10, rounded down
func FUNC_1 (score:String) -> int:
	#Provided includes a plus
	var extra = 0
	var core = 0
	if(score.find("+")>0):
		extra = score.get_slice("+", 1).to_int()
	var die = score.get_slice("D", 0).to_int()
	if(die > 0):
		core = (die-1)*25
	var mods = extra*10
	return(core+mods)
	
#DKM TEMP:
#First average dice (add/2; remainder to +; Plus of 3 and up adds D+1?), then as above
func FUNC_2 (score1:String, score2:String) -> int:
	#Provided includes a plus
	var extra = 0
	var core = 0
	var die = 0
	#First combine the additions, and if 3+, increment the D
	if(score1.find("+")>0):
		extra = score1.get_slice("+", 1).to_int()
	if(score2.find("+")>0):
		extra = extra + score2.get_slice("+", 1).to_int()		
	var die1 = score1.get_slice("D", 0).to_int()
	var die2 = score2.get_slice("D", 0).to_int()
	var dieCombo = die1 + die2
	if(extra >=3):
		extra = extra-3
		dieCombo = dieCombo+1
	#Now average:
	die = dieCombo/2
	if(die > 0):
		core = (die-1)*25
	var mods = extra*10
	return(core+mods)	

