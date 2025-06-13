# Global script for running conversions specific to the D20 game system.
# This is used to convert BCI-RPG backend characters into D20-compatible format.

class_name D20_Converter

# Maps BCI backend stats to D20 stats
# The value is a string for the D20 output label and the function to use for conversion
const ability_match = {
	"ST": "STR|FUNC_1",
	"RE": "INT|FUNC_AVG_RE_ME",
	"ME": "INT|FUNC_AVG_RE_ME",
	"IN": "WIS|FUNC_AVG_IN_EM",
	"EM": "WIS|FUNC_AVG_IN_EM",
	"AG": "DEX|FUNC_AVG_AG_MD_QU",
	"MD": "DEX|FUNC_AVG_AG_MD_QU",
	"QU": "DEX|FUNC_AVG_AG_MD_QU",
	"CO": "CON|FUNC_1",
	"CH": "CHA|FUNC_AVG_CHA",
	"PR": "CHA|FUNC_AVG_CHA",
	"MX": "CHA|FUNC_AVG_CHA",
	"SD": "CHA|FUNC_AVG_CHA"
}

# Return the mapping dictionary
func get_ability_match() -> Dictionary:
	return ability_match

# Direct percentile → D20 formula: round(percentile / 5) + 1
func FUNC_1(value: int) -> int:
	return clamp(round(value / 5.0) + 1, 1, 20)

# Averages of specific stat groups
func FUNC_AVG_RE_ME(re_val: int, me_val: int) -> int:
	var avg = (re_val + me_val) / 2.0s
	return FUNC_1(avg)

func FUNC_AVG_IN_EM(in_val: int, em_val: int) -> int:
	var avg = (in_val + em_val) / 2.0
	return FUNC_1(avg)

func FUNC_AVG_AG_MD_QU(ag: int, md: int, qu: int) -> int:
	var avg = (ag + md + qu) / 3.0
	return FUNC_1(avg)

func FUNC_AVG_CHA(ch: int, pr: int, mx: int, sd: int) -> int:
	var avg = (ch + pr + mx + sd) / 4.0
	return FUNC_1(avg)

# Optional test helper
func get_HW() -> String:
	return "Hello D20 World!"
