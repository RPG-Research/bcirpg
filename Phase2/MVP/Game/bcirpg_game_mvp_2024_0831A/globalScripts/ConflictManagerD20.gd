#CONFLICT MANAGER (D20):
#	Rules helper for the d20 conflict system. The original design and rules are
#	Ning's (PR #86); this file keeps those rules and tries to make them easier to
#	test and reuse.
#	What it is meant to do:
#		- map an intent (talk / move / do / fight) to the capabilities that suit it
#		- convert a backend percentile capability into a d20 modifier
#		- run a contested d20 roll and turn the margin into an outcome tier
#		- build the default NPC used by the demo conflicts
#	It holds no conflict state. The session classes in res://gamePlay/conflict/
#	own the state of a running conflict and call into this class for the rules.

extends Reference
class_name ConflictManagerD20

const D20_Converter_Source := preload("res://globalScripts/D20_Converter.gd")

#The four intents a combatant can declare in a simple conflict.
const INTENTS = ["talk", "move", "do", "fight"]

#Capabilities that suit each intent. The "do" group is every backend capability
#	that a general action could reasonably draw on.
const INTENT_CAP_GROUPS = {
	"talk": ["CH", "PR", "MX", "SD"],
	"move": ["AG", "MD", "QU"],
	"fight": ["ST", "AG", "CO"],
	"do": ["AG", "CO", "QU", "MD", "ST", "RE", "ME", "IN", "EM", "CH", "PR", "MX", "SD"]
}

#Margin thresholds (actor total minus opponent total) for each outcome tier.
const CRIT_MARGIN = 10
const STRONG_MARGIN = 5
const WEAK_MARGIN = 1

var _converter = D20_Converter_Source.new()
var _rng: RandomNumberGenerator

#FUNCTION: Init
#Params: optional RandomNumberGenerator. Tests pass a seeded generator so rolls
#	can be repeated; normal play passes nothing and gets a randomized generator.
#Returns: nothing
#Notes: this uses Godot's own RandomNumberGenerator rather than DieManager, so the
#	d20 rolls can be seeded and do not depend on DieManager's percentile logic.
func _init(rng: RandomNumberGenerator = null):
	if rng == null:
		_rng = RandomNumberGenerator.new()
		_rng.randomize()
	else:
		_rng = rng

#FUNCTION: Intent capability group
#Params: intent name (case-insensitive)
#Returns: Array of capability names that suit the intent
#Notes: an unknown intent is a programming or module error, so it is reported
#	loudly and an empty Array is returned for the caller to handle.
func intent_cap_group(intent: String) -> Array:
	var key = intent.to_lower()
	if not INTENT_CAP_GROUPS.has(key):
		push_error("ConflictManagerD20: unknown intent '%s'; expected one of %s" % [intent, str(INTENTS)])
		return []
	return INTENT_CAP_GROUPS[key]

#FUNCTION: All intent capabilities
#Params: none
#Returns: Array of every capability used by any intent group, without duplicates
#Notes: sessions use this to check up front that the PC has what a conflict needs.
func all_intent_caps() -> Array:
	var caps = []
	for intent in INTENTS:
		for cap_name in INTENT_CAP_GROUPS[intent]:
			if not caps.has(cap_name):
				caps.append(cap_name)
	return caps

#FUNCTION: Pick NPC intent
#Params: none
#Returns: one of INTENTS, chosen at random
#Notes: this is the very simple NPC "AI" from the original design.
func pick_npc_intent() -> String:
	return INTENTS[_rng.randi_range(0, INTENTS.size() - 1)]

#FUNCTION: Make default NPC
#Params: name to give the NPC
#Returns: Dictionary with name, caps (percentile scores), hp, and status flags
#Notes: the values are the demo "Bandit" from the original design.
func make_default_npc(npc_name: String = "Bandit") -> Dictionary:
	var caps = {
		"ST": 55, "AG": 50, "CO": 45,
		"RE": 40, "ME": 40, "IN": 35, "EM": 35,
		"CH": 30, "PR": 30, "MX": 30, "SD": 30,
		"MD": 45, "QU": 45
	}
	return {
		"name": npc_name,
		"caps": caps,
		"hp": 12,
		"status": {"hidden": false, "dodging": false}
	}

#FUNCTION: Contested roll
#Params: actor and opponent percentile scores, plus optional situational modifiers
#Returns: Dictionary {"actor": {roll, mod, total}, "opponent": {roll, mod, total},
#	"margin": actor total - opponent total, "outcome": tier name}
#Notes: "actor" is whoever is acting this time (the PC or the NPC), so the margin
#	is always read from the actor's point of view.
func contested_roll(actor_percent: int, opponent_percent: int, situational_actor: int = 0, situational_opponent: int = 0) -> Dictionary:
	var actor_mod = percentile_to_d20_mod(actor_percent) + situational_actor
	var opponent_mod = percentile_to_d20_mod(opponent_percent) + situational_opponent

	var actor_roll = roll_d20()
	var opponent_roll = roll_d20()

	var actor_total = actor_roll + actor_mod
	var opponent_total = opponent_roll + opponent_mod
	var margin = actor_total - opponent_total

	return {
		"actor": {"roll": actor_roll, "mod": actor_mod, "total": actor_total},
		"opponent": {"roll": opponent_roll, "mod": opponent_mod, "total": opponent_total},
		"margin": margin,
		"outcome": margin_to_outcome(margin)
	}

#FUNCTION: Percentile to d20 modifier
#Params: percentile score (clamped to 0-100)
#Returns: d20-style ability modifier
#Notes: converts with D20_Converter.FUNC_1 to a 1-20 score, then applies the
#	usual (score - 10) / 2 rounded down.
func percentile_to_d20_mod(percent: int) -> int:
	var score20 = _converter.FUNC_1(int(clamp(percent, 0, 100)))
	return int(floor((score20 - 10) / 2.0))

#FUNCTION: Margin to outcome
#Params: margin (actor total - opponent total)
#Returns: outcome tier name
func margin_to_outcome(margin: int) -> String:
	if margin >= CRIT_MARGIN:
		return "CRIT_SUCCESS"
	elif margin >= STRONG_MARGIN:
		return "STRONG_SUCCESS"
	elif margin >= WEAK_MARGIN:
		return "WEAK_SUCCESS"
	elif margin == 0:
		return "TIE"
	elif margin <= -CRIT_MARGIN:
		return "CRIT_FAIL"
	else:
		return "FAIL"

#FUNCTION: Roll d20
#Params: none
#Returns: integer from 1 to 20
func roll_d20() -> int:
	return _rng.randi_range(1, 20)
