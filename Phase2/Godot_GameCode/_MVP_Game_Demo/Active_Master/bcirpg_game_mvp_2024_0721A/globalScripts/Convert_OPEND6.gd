#Global script for running conversions specific to the OpenD6 game
#	system. This will be called by the GSP as needed.

class_name OpenD6_Converter

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
func FUNC_1 (die:int, bonus:int) -> int:
	return(0)
	
#DKM TEMP:
#First average dice (add/2; remainder to +; Plus of 3 and up adds D+1?), then as above
func FUNC_2 (source:String) -> int:
	return(0)
