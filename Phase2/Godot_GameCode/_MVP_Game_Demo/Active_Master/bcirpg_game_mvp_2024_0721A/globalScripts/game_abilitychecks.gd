#Methods here will take a target capacity, mods, amount to beat (optional) and return 
#	a check_result object

extends Node

class_name AbilityChecks

const Check_Result := preload("res://globalScripts/game_checkresult.gd") 

#FUNCTION Make Player Check
#Params: ability, difficulty modifier (to add/remove to ability), and optional amount to beat
#Returns: A check result object, which gives bool for pass, crit success or fail, and also
#	returns the actual number generated. If no to_beat is provided, it checks the ability+mod.
#Notes: As long as the capacity is found by name, it will return the rolled value.
func make_player_check (ability:String, diff_mod:int, to_beat:int = -1)->Check_Result:
	var results = Check_Result.new()
	var pSingleton = PlayerCharacter.pc
	for player_capacity in pSingleton.player_capabilities:
		if player_capacity.name==str(ability.strip_edges(true,true).to_upper()):
			DiceRoller.dieManager.clearData()
			var perc_die = [10,10]
			DiceRoller.dieManager.setDieManager(perc_die, 0.5)
			var die_handler = DiceRoller.dieManager.rollDice()
			results.rolled = int(die_handler[1]*100)
			#DKM TEMP: test output only:
			print("Inside ability check, got these back in my roll array: " + str(results.rolled))
			if results.rolled >=95:
				results.fail_crit = true
			elif results.rolled <=5:
				results.win_crit = true
			var total_ability_score = int(player_capacity.score) + int(player_capacity.modifier) + int(diff_mod)
			if to_beat != -1:
				if total_ability_score <= to_beat:
					results.check_pass = true
				else:
					results.check_pass = false
			#Here it's a check of ability score with provided diff mod (no set # to beat)
			else:
				if total_ability_score >= results.rolled:
					results.check_pass = true
				else:
					results.check_pass = false				
				pass
	return results
