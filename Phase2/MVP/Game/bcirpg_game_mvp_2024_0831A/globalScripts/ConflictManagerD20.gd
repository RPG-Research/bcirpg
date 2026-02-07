extends Node
class_name ConflictManagerD20

const D20_Converter_Source := preload("res://globalScripts/D20_Converter.gd")

var _converter = null
var _d20_manager = null

func _init():
	_converter = D20_Converter_Source.new()
	_d20_manager = DieManager.new([20], 0.0)

# Intent -> recommended capabilities
func intent_cap_group(intent: String) -> Array:
	match intent.to_lower():
		"talk":
			return ["CH", "PR", "MX", "SD"]
		"move":
			return ["AG", "MD", "QU"]
		"fight":
			return ["ST", "AG", "CO"]
		"do":
			return ["AG","CO","QU","MD","ST","RE","ME","IN","EM","CH","PR","MX","SD"]
		_:
			return []

func make_default_npc(name: String = "Bandit") -> Dictionary:
	var caps = {
		"ST": 55, "AG": 50, "CO": 45,
		"RE": 40, "ME": 40, "IN": 35, "EM": 35,
		"CH": 30, "PR": 30, "MX": 30, "SD": 30,
		"MD": 45, "QU": 45
	}
	return {
		"name": name,
		"caps": caps,
		"hp": 12,
		"status": {"hidden": false, "dodging": false, "disengaged": false}
	}

func contested_roll(pc_percent: int, npc_percent: int, situational_pc: int = 0, situational_npc: int = 0) -> Dictionary:
	var pc_mod = percentile_to_d20_mod(pc_percent) + situational_pc
	var npc_mod = percentile_to_d20_mod(npc_percent) + situational_npc

	var pc_roll = roll_d20()
	var npc_roll = roll_d20()

	var pc_total = pc_roll + pc_mod
	var npc_total = npc_roll + npc_mod

	var margin = pc_total - npc_total
	var outcome = margin_to_outcome(margin)

	return {
		"pc": {"roll": pc_roll, "mod": pc_mod, "total": pc_total},
		"npc": {"roll": npc_roll, "mod": npc_mod, "total": npc_total},
		"margin": margin,
		"outcome": outcome
	}

func percentile_to_d20_mod(percent: int) -> int:
	var score20 = _converter.FUNC_1(int(clamp(percent, 0, 100)))
	return int(floor((score20 - 10) / 2.0))

func margin_to_outcome(margin: int) -> String:
	if margin >= 10:
		return "CRIT_SUCCESS"
	elif margin >= 5:
		return "STRONG_SUCCESS"
	elif margin >= 1:
		return "WEAK_SUCCESS"
	elif margin == 0:
		return "TIE"
	elif margin <= -10:
		return "CRIT_FAIL"
	else:
		return "FAIL"

func roll_d20() -> int:
	_d20_manager.clearData()
	_d20_manager.setDieManager([20], 0.0)
	var res = _d20_manager.rollDice()
	if res.size() > 0 and res[0].size() > 0:
		return int(res[0][0])
	return 1
