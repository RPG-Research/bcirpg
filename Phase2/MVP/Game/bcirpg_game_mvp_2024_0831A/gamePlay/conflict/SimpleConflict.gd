#SIMPLE CONFLICT:
#	A single contested exchange (Ning's "Diagram 1" design, PR #86):
#		1. the player picks an intent (talk / move / do / fight)
#		2. the player picks a capability that suits that intent
#		3. the NPC picks a random intent and its best capability for it
#		4. one contested d20 roll decides the result; if either side chose
#		   "fight", the loser of the roll takes a little damage
#	Started by a module space whose Action is StartSimpleConflict.

extends "res://gamePlay/conflict/ConflictSession.gd"

const CHOOSE_INTENT_STEP = "choose_intent"
const CHOOSE_TRAIT_STEP = "choose_trait"

var pc_intent = ""

#FUNCTION: Init
#Params: rules, pc_stats, view (passed through to ConflictSession)
func _init(rules_ref, pc_stats_ref, view_ref).(rules_ref, pc_stats_ref, view_ref):
	pass

#FUNCTION: Required capabilities
#Notes: every capability any intent can use, so the trait list is never empty
func _required_caps() -> Array:
	return rules.all_intent_caps()

func _on_start() -> void:
	step = CHOOSE_INTENT_STEP
	say("[Conflict] %s confronts you. Choose your intent." % npc["name"])

func _on_choice(kind: String, value: String) -> void:
	match kind:
		"intent":
			if not rules.INTENTS.has(value):
				show_error("Unknown intent '%s'." % value)
				return
			pc_intent = value
			step = CHOOSE_TRAIT_STEP
			say("[Conflict] Using what? Pick a trait for intent: " + pc_intent)
		"trait":
			if not rules.intent_cap_group(pc_intent).has(value):
				show_error("Trait '%s' does not belong to intent '%s'." % [value, pc_intent])
				return
			_resolve(value)
			step = END_STEP
		"nav":
			step = CHOOSE_INTENT_STEP
			say("[Conflict] Choose your intent.")
		_:
			show_error("Unknown conflict choice kind '%s'." % kind)

func _build_options() -> void:
	match step:
		CHOOSE_INTENT_STEP:
			for intent in rules.INTENTS:
				add_option(intent.capitalize(), "intent", intent)
		CHOOSE_TRAIT_STEP:
			for cap_name in rules.intent_cap_group(pc_intent):
				add_option(cap_name, "trait", cap_name)
			add_option("Back", "nav", "back")
		_:
			push_error("SimpleConflict: no options defined for step '%s'" % step)

#FUNCTION: Resolve (internal)
#Params: the capability the player chose
#Returns: nothing; rolls the exchange, applies damage, and says the result
func _resolve(pc_trait: String) -> void:
	var npc_intent = rules.pick_npc_intent()
	var npc_trait = _npc_best_trait(npc_intent)

	var roll = rules.contested_roll(pc_stats.get_percent(pc_trait), int(npc["caps"][npc_trait]))
	var margin = int(roll["margin"])
	var outcome = str(roll["outcome"])

	var winner = "TIE"
	if margin > 0:
		winner = "PC"
	elif margin < 0:
		winner = "NPC"

	say("[Conflict Result]")
	say("PC intent: %s (using %s)" % [pc_intent, pc_trait])
	say("NPC intent: %s (using %s)" % [npc_intent, npc_trait])
	say("PC roll %d + mod %d = %d" % [roll["actor"]["roll"], roll["actor"]["mod"], roll["actor"]["total"]])
	say("NPC roll %d + mod %d = %d" % [roll["opponent"]["roll"], roll["opponent"]["mod"], roll["opponent"]["total"]])
	say("Outcome: %s (margin %d) => %s" % [winner, margin, outcome])

	#Small damage when either side fights, to show the loop working (original MVP rule).
	if pc_intent == "fight" or npc_intent == "fight":
		var damage = 1 + int(abs(margin) / 5)
		if outcome == "CRIT_SUCCESS" or outcome == "CRIT_FAIL":
			damage += 2
		if margin > 0:
			npc["hp"] = int(npc["hp"]) - damage
			say("PC hits %s for %d damage. NPC HP now %d." % [npc["name"], damage, npc["hp"]])
		elif margin < 0:
			pc_stats.take_damage(damage)
			say("NPC hits PC for %d damage. PC HP now %d." % [damage, pc_stats.get_hp()])
			if pc_stats.get_hp() <= 0:
				say("You are defeated.")
		else:
			say("No damage (tie).")

#FUNCTION: NPC best trait (internal)
#Params: the NPC's intent
#Returns: the NPC capability with the highest score in that intent's group
func _npc_best_trait(intent: String) -> String:
	var best = ""
	var best_val = -1
	for cap_name in rules.intent_cap_group(intent):
		var val = int(npc["caps"].get(cap_name, -1))
		if val > best_val:
			best_val = val
			best = cap_name
	if best == "":
		push_error("SimpleConflict: NPC '%s' has none of the capabilities for intent '%s'" % [npc["name"], intent])
	return best
