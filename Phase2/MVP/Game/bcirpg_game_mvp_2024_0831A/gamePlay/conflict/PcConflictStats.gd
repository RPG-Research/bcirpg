#PC CONFLICT STATS:
#	Gives the conflict sessions read/write access to the player character's
#	capabilities (scores, Health, damage), so the sessions do not reach into
#	the PlayerCharacter singleton directly.
#	Capability names are matched case-insensitively ("Health" == "HEALTH").
#	A missing capability is reported loudly instead of being treated as 0. The
#	earlier version returned 0, which is why some characters started a fight
#	with 0 HP: "Health" (and AG, ST, ...) only exist on BCIRPG_PERCENTILE
#	characters, and Health is calculated from CO when the character is saved.

extends Reference

const HEALTH_CAP = "Health"

#The playerCharacterTemplate being read (PlayerCharacter.pc).
var _pc

#FUNCTION: Init
#Params: the playerCharacterTemplate to read from and write to
func _init(pc):
	_pc = pc

#FUNCTION: Find start problem
#Params: Array of capability names the conflict needs
#Returns: "" when the PC can take part, otherwise a message explaining what is wrong
#Notes: sessions call this before anything else, so later lookups can rely on
#	the capabilities being there.
func find_start_problem(required_caps: Array) -> String:
	if _pc == null:
		return "No player character is loaded."
	var missing = []
	for cap_name in required_caps + [HEALTH_CAP]:
		if _find_cap(cap_name) == null and not missing.has(cap_name):
			missing.append(cap_name)
	if missing.size() > 0:
		return ("The character '%s' is missing capabilities this conflict needs: %s. " +
			"The conflict system currently needs a BCIRPG_PERCENTILE character " +
			"(choose it under Settings, then save or load the character).") % [str(_pc.name), PoolStringArray(missing).join(", ")]
	if get_hp() <= 0:
		return ("The character '%s' has %d Health. Health is calculated from CO when the " +
			"character is saved, so check the CO score.") % [str(_pc.name), get_hp()]
	return ""

#FUNCTION: Has capability
#Params: capability name
#Returns: true when the PC has a capability with that name
func has_cap(cap_name: String) -> bool:
	return _find_cap(cap_name) != null

#FUNCTION: Get percent
#Params: capability name
#Returns: score + modifier for that capability
func get_percent(cap_name: String) -> int:
	var cap = _require_cap(cap_name)
	return int(cap.score) + int(cap.modifier)

#FUNCTION: Get HP
#Params: none
#Returns: the PC's current Health score
func get_hp() -> int:
	return int(_require_cap(HEALTH_CAP).score)

#FUNCTION: Take damage
#Params: damage amount
#Returns: nothing; lowers the PC's Health score
#Notes: this changes the loaded character itself, as in the original design,
#	so damage carries over after the conflict ends.
func take_damage(damage: int) -> void:
	var cap = _require_cap(HEALTH_CAP)
	cap.score = int(cap.score) - damage

#FUNCTION: Find capability (internal)
#Params: capability name
#Returns: the matching Char_Capability, or null when there is none
func _find_cap(cap_name: String):
	for cap in _pc.player_capabilities:
		if cap != null and str(cap.name).to_upper() == cap_name.to_upper():
			return cap
	return null

#FUNCTION: Require capability (internal)
#Params: capability name
#Returns: the matching Char_Capability
#Notes: reaching the error here means a session skipped find_start_problem() or
#	asked for a capability it did not list as required. The error names the
#	capability so it can be fixed; in debug builds the assert stops right here.
func _require_cap(cap_name: String):
	var cap = _find_cap(cap_name)
	if cap == null:
		var msg = "PcConflictStats: character '%s' has no capability '%s'; the conflict session should have listed it as required." % [str(_pc.name), cap_name]
		push_error(msg)
		assert(false, msg)
	return cap
