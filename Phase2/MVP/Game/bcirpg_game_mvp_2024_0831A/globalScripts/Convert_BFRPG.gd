#Global script for running conversions specific to the OpenD6 game
#	system. This will be called by the GSP as needed.

class_name BFRPG_Converter


const system_abilities = ["STR", "INT", "WIS", "DEX", "CON", "CHR"]


const ability_match = { "AG":"DEX|FUNC_1",
	"APP":"CHR|FUNC_1",
	"CO":"CON|FUNC_1",
	"QU":"DEX/STR|FUNC_2",
	"MD":"DEX|FUNC_1",
	"ST":"STR|FUNC_1",
	"CH":"CHR/WIS|FUNC_2",
	"EM":"WIS|FUNC_1",
	"IN":"WIS|FUNC_1",
	"ME":"INT|FUNC_1",
	"MX":"WIS/INT|FUNC_2",
	"PR":"CHR/WIS|FUNC_2",
	"RE":"INT|FUNC_1",
	"SD":"CON/WIS|FUNC_2"
}

func get_ability_match()->Dictionary:
	return ability_match
	
func get_system_abilities()->Array:
	return system_abilities
	
func get_system_input_type()->String:
	return "Int"
	
func get_HW() -> String:
	return ("Hello BFRPG World!")

func FUNC_1 (score:String) -> int:
	var core = int(score)
	var perc = 0
	if(core > 0):
		if (core > 20):
			core = 20
		perc = core*5
	return(perc)
	
func FUNC_2 (score1:String, score2:String) -> int:
	var core1 = int(score1)
	var core2 = int(score2)
	var perc = 0
	if(core1 > 0):
		if (core1 > 20):
			core1 = 20
	if(core2 > 0):
		if (core2 > 20):
			core2 = 20
	perc = (round((core1 + core2)/2)*5)
	return(perc)
