#EXTENDED CONFLICT:
#	Turn-based combat against one NPC (Ning's "Diagrams 2/3/4" design, PR #86).
#		- initiative: contested AG roll; the winner acts first each round
#		- on the player's turn: Move once and take one Action (Attack, Hide, or
#		  Dodge), or Flee; End turn once you have moved or acted
#		- on the NPC's turn: it searches if the player is hidden, otherwise attacks
#		- the conflict ends when either side reaches 0 HP or the player flees
#	Started by a module space whose Action is StartExtendedConflict.
#	Changes from the first version, all intended to match its own descriptions:
#		- one Action per turn is enforced (before, Attack could be pressed any
#		  number of times in a single turn)
#		- the NPC's attacks can now end the conflict when the player reaches 0 HP
#		- Dodge lasts until the start of the player's next turn, as its text says
#		- the round counter goes up once both sides have acted
#		- Help, Set reaction, Spell, and Disengage were removed for now. They used
#		  up the player's action but had no effect yet (no allies, reactions,
#		  spells, or opportunity attacks exist). They can return once those
#		  systems exist.

extends "res://gamePlay/conflict/ConflictSession.gd"

const PC_SIDE = "pc"
const NPC_SIDE = "npc"
const WAIT_STEP = "wait"         #a Continue button, then the side in "turn" acts
const PC_CHOOSE_STEP = "pc_choose"

#Situational penalty to an attack roll when the target is dodging (original MVP rule).
const DODGE_PENALTY = 2

var round_number = 1
var first_side = PC_SIDE
var turn = PC_SIDE
var pc_moved = false
var pc_acted = false
var pc_hidden = false
var pc_dodging = false

#FUNCTION: Init
#Params: rules, pc_stats, view (passed through to ConflictSession)
func _init(rules_ref, pc_stats_ref, view_ref).(rules_ref, pc_stats_ref, view_ref):
	pass

func _required_caps() -> Array:
	return ["AG", "ST", "IN"]

#FUNCTION: On start
#Notes: rolls initiative. A tie goes to the player, as in the original design.
func _on_start() -> void:
	say("[Combat] Extended conflict with %s started. Rolling initiative..." % npc["name"])
	var roll = rules.contested_roll(pc_stats.get_percent("AG"), int(npc["caps"]["AG"]))
	if int(roll["margin"]) >= 0:
		first_side = PC_SIDE
	else:
		first_side = NPC_SIDE
	turn = first_side
	say("[Initiative] PC total %d vs NPC total %d. %s goes first." % [roll["actor"]["total"], roll["opponent"]["total"], first_side.to_upper()])
	step = WAIT_STEP

func _on_choice(kind: String, value: String) -> void:
	if kind == "flow" and step == WAIT_STEP:
		if turn == PC_SIDE:
			_begin_pc_turn()
		else:
			_run_npc_turn()
	elif kind == "act" and step == PC_CHOOSE_STEP:
		_handle_pc_action(value)
	else:
		show_error("Choice '%s:%s' is not valid during step '%s'." % [kind, value, step])

func _build_options() -> void:
	match step:
		WAIT_STEP:
			add_option("Continue", "flow", "next")
		PC_CHOOSE_STEP:
			if not pc_moved:
				add_option("Move", "act", "move")
			if not pc_acted:
				add_option("Attack", "act", "attack")
				add_option("Hide", "act", "hide")
				add_option("Dodge", "act", "dodge")
			add_option("Flee", "act", "flee")
			if pc_moved or pc_acted:
				add_option("End turn", "act", "endturn")
		_:
			push_error("ExtendedConflict: no options defined for step '%s'" % step)

#FUNCTION: Begin PC turn (internal)
#Notes: resets the per-turn flags; Dodge from the previous turn wears off here
func _begin_pc_turn() -> void:
	pc_moved = false
	pc_acted = false
	pc_dodging = false
	say("[Round %d] PC HP %d | %s HP %d" % [round_number, pc_stats.get_hp(), npc["name"], npc["hp"]])
	say("[Your turn] Choose action (you may Move + 1 Action).")
	step = PC_CHOOSE_STEP

#FUNCTION: Handle PC action (internal)
#Params: action name from the pressed option
func _handle_pc_action(action: String) -> void:
	match action:
		"move":
			pc_moved = true
			say("[Move] You reposition. (Distance is not tracked yet.)")
		"attack":
			pc_acted = true
			say(_pc_attack())
			if _check_end():
				return
		"hide":
			pc_acted = true
			say(_pc_try_hide())
		"dodge":
			pc_acted = true
			pc_dodging = true
			say("[Dodge] Until your next turn, attacks against you are harder.")
		"flee":
			say("[Flee] You leave the conflict.")
			step = END_STEP
			return
		"endturn":
			_end_turn()
			say("[Round %d] %s's turn." % [round_number, npc["name"]])
			step = WAIT_STEP
			return
		_:
			show_error("Unknown action '%s'." % action)
			return
	say("[Your turn] Choose another option or End turn.")

#FUNCTION: Run NPC turn (internal)
#Notes: very simple NPC behavior from the original design
func _run_npc_turn() -> void:
	if pc_hidden:
		var search = rules.contested_roll(int(npc["caps"]["IN"]), pc_stats.get_percent("AG"))
		if int(search["margin"]) > 0:
			pc_hidden = false
			say("[NPC] %s spots you! (You are no longer hidden)" % npc["name"])
		else:
			say("[NPC] %s searches but can't find you." % npc["name"])
	else:
		var situational = 0
		if pc_dodging:
			situational -= DODGE_PENALTY
		var roll = rules.contested_roll(int(npc["caps"]["ST"]), pc_stats.get_percent("AG"), situational, 0)
		var margin = int(roll["margin"])
		if margin > 0:
			var damage = 2 + int(margin / 5)
			if str(roll["outcome"]) == "CRIT_SUCCESS":
				damage += 3
			pc_stats.take_damage(damage)
			say("[NPC] %s hits you for %d damage. PC HP now %d." % [npc["name"], damage, pc_stats.get_hp()])
		else:
			say("[NPC] %s attacks but misses." % npc["name"])
	if _check_end():
		return
	_end_turn()
	step = WAIT_STEP

#FUNCTION: PC attack (internal)
#Returns: text describing the attack (PC ST vs NPC AG)
func _pc_attack() -> String:
	var roll = rules.contested_roll(pc_stats.get_percent("ST"), int(npc["caps"]["AG"]))
	var margin = int(roll["margin"])
	var outcome = str(roll["outcome"])
	var text = "[Attack] PC %d vs NPC %d (margin %d => %s)\n" % [roll["actor"]["total"], roll["opponent"]["total"], margin, outcome]
	if margin > 0:
		var damage = 2 + int(margin / 5)
		if outcome == "CRIT_SUCCESS":
			damage += 3
		npc["hp"] = int(npc["hp"]) - damage
		text += "Hit! Dealt %d damage. %s HP now %d." % [damage, npc["name"], npc["hp"]]
	else:
		text += "Miss."
	return text

#FUNCTION: PC try hide (internal)
#Returns: text describing the attempt (PC AG vs NPC IN)
func _pc_try_hide() -> String:
	var roll = rules.contested_roll(pc_stats.get_percent("AG"), int(npc["caps"]["IN"]))
	if int(roll["margin"]) > 0:
		pc_hidden = true
		return "[Hide] Success. You are hidden."
	return "[Hide] Failed. They keep track of you."

#FUNCTION: End turn (internal)
#Notes: passes the turn to the other side; a new round starts when the turn
#	comes back to whoever went first
func _end_turn() -> void:
	if turn == PC_SIDE:
		turn = NPC_SIDE
	else:
		turn = PC_SIDE
	if turn == first_side:
		round_number += 1

#FUNCTION: Check end (internal)
#Returns: true (and moves to the end step) when either side is at 0 HP or below
func _check_end() -> bool:
	if int(npc["hp"]) <= 0:
		say("[Combat] %s is defeated." % npc["name"])
		step = END_STEP
		return true
	if pc_stats.get_hp() <= 0:
		say("[Combat] You are defeated.")
		step = END_STEP
		return true
	return false
