# CombatManager.gd
# This implements a combat system based on BCI-RPG rules. 
# I'm adding it under globalScripts for now but can move it depending on where we want it to be. 

class_name CombatManager

# Constants for difficulty levels
const DIFFICULTY = {
	"AUTOMATIC_SUCCESS": 11,
	"ROUTINE": 2,
	"VERY_EASY": 3,
	"EASY": 4,
	"AVERAGE": 5,
	"MEDIUM": 6,
	"VERY_DIFFICULT": 7,
	"EXTREMELY_DIFFICULT": 8,
	"LUDICROUS": 9,
	"EPIC_ABSURDITY": 10,
	"IMPOSSIBLE": 11
}

# Constants for difficulty modifiers
const DIFFICULTY_MODIFIER = {
	"AUTOMATIC_SUCCESS": 100,  # Automatic success
	"ROUTINE": 75,
	"VERY_EASY": 50,
	"EASY": 25,
	"AVERAGE": 0,
	"MEDIUM": -25,
	"VERY_DIFFICULT": -50,
	"EXTREMELY_DIFFICULT": -75,
	"LUDICROUS": -90,
	"EPIC_ABSURDITY": -99,
	"IMPOSSIBLE": -100  # Automatic failure
}

# Reference to the die manager
var dieManager

# Reference to player character
var player

# Reference to current opponent
var opponent

# Combat status variables
var combat_active = false
var current_turn = "player"  # "player" or "opponent"
var round_number = 0

# Initialize the combat manager
func _init():
	# Create a die manager for percentage dice (two d10s)
	dieManager = DieManager.new([10, 10], 0.5)

# Start a new combat encounter
func start_combat(player_ref, opponent_ref):
	player = player_ref
	opponent = opponent_ref
	combat_active = true
	round_number = 1
	current_turn = "player"
	
	return "Combat started between " + player.name + " and " + opponent.name

# End the current combat encounter
func end_combat():
	combat_active = false
	
	var result = "Combat ended."
	if player.is_alive():
		if !opponent.is_alive():
			result += " " + player.name + " is victorious!"
		else:
			result += " Combat was interrupted."
	else:
		result += " " + player.name + " has been defeated."
	
	return result

# Advance to the next turn or round
func next_turn():
	if current_turn == "player":
		current_turn = "opponent"
	else:
		current_turn = "player"
		round_number += 1
	
	return "Round " + str(round_number) + ", " + current_turn + "'s turn."

# Perform an attack action
# stat_or_skill: The attribute or skill to use for the attack
# difficulty: The difficulty level of the attack (from DIFFICULTY enum)
# Returns: A dictionary with the attack results
func attack(attacker, defender, stat_or_skill, difficulty="AVERAGE"):
	var result = {}
	
	# Get the base percentage based on the stat or skill being used
	var base_percentage = get_character_value(attacker, stat_or_skill)
	
	# Apply difficulty modifier to the base percentage
	var difficulty_mod = DIFFICULTY_MODIFIER[difficulty]
	var modified_percentage = clamp(base_percentage + difficulty_mod, 0, 100) / 100.0
	
	# Set up the die manager with the modified percentage as the passing threshold
	dieManager.clearData()
	dieManager.setDieManager([10, 10], modified_percentage)
	
	# Roll the dice and get the result
	var roll_result = dieManager.rollDice()
	var success = roll_result[2]  # pass/fail result
	
	# Prepare result information
	result["attacker"] = attacker.name
	result["defender"] = defender.name
	result["stat_used"] = stat_or_skill
	result["base_percentage"] = base_percentage
	result["difficulty"] = difficulty
	result["difficulty_mod"] = difficulty_mod
	result["modified_percentage"] = modified_percentage * 100
	result["roll_percentage"] = roll_result[1] * 100
	result["success"] = success
	result["degree_of_success"] = roll_result[4] * 100
	
	# Calculate damage if attack was successful
	if success:
		# For MVP, use a simple damage calculation
		# The damage is proportional to the degree of success and the attacker's strength
		var base_damage = 5  # Base damage value
		var strength_modifier = get_character_value(attacker, "ST") / 50.0  # Normalize strength to 0-2 range
		var damage = int(base_damage * strength_modifier * (1 + max(0, roll_result[4])))
		
		# Apply damage to defender
		defender.take_damage(damage)
		
		result["damage"] = damage
		result["message"] = attacker.name + " successfully attacks " + defender.name + " for " + str(damage) + " damage!"
	else:
		result["damage"] = 0
		result["message"] = attacker.name + " attempts to attack " + defender.name + " but misses!"
	
	return result

# Perform a defend action - increases defense for next round
func defend(character):
	character.defending = true
	return character.name + " takes a defensive stance."

# Check if character has the given stat or skill
func has_stat_or_skill(character, stat_or_skill):
	if stat_or_skill in character.attributes:
		return true
	elif stat_or_skill in character.skills:
		return true
	return false

# Get the value of a character's stat or skill
func get_character_value(character, stat_or_skill):
	if stat_or_skill in character.attributes:
		return character.attributes[stat_or_skill]
	elif stat_or_skill in character.skills:
		return character.skills[stat_or_skill]
	return 0

# Execute an AI turn for the opponent. (Not literal AI fyi. This is just for the computer's turns)
func execute_ai_turn():
	if !combat_active || current_turn != "opponent" || !opponent.is_alive():
		return "No valid opponent turn to execute."
	
	var action_result = ""
	
	# Simple AI: Always attack using highest physical attribute
	var best_stat = "ST"  # Default to strength
	var best_value = get_character_value(opponent, "ST")
	
	# Find the highest physical attribute
	for stat in ["AG", "ST", "CO", "QU", "MD"]:
		var value = get_character_value(opponent, stat)
		if value > best_value:
			best_value = value
			best_stat = stat
	
	# Execute attack using best stat
	var attack_result = attack(opponent, player, best_stat)
	action_result = attack_result["message"]
	
	# Advance to next turn
	next_turn()
	
	return action_result

# Run a complete combat sequence (for testing later. I haven't tested this yet but added it for later)
func run_test_combat(player_ref, opponent_ref):
	var combat_log = []
	
	# Start combat
	combat_log.append(start_combat(player_ref, opponent_ref))
	
	# Run combat until one combatant is defeated or 20 rounds pass
	while combat_active && round_number <= 20:
		if current_turn == "player":
			# Player always attacks with strength in this test
			var attack_result = attack(player, opponent, "ST")
			combat_log.append(attack_result["message"])
			
			if !opponent.is_alive():
				combat_log.append(end_combat())
				break
				
			next_turn()
		else:
			combat_log.append(execute_ai_turn())
			
			if !player.is_alive():
				combat_log.append(end_combat())
				break
	
	if combat_active:
		combat_log.append("Combat reached maximum number of rounds.")
		combat_log.append(end_combat())
	
	return combat_log
