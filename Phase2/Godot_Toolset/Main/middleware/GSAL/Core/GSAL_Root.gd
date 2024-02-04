extends Node

# Section 1 (Define Ruleset)
# Work of a precentage for the character sheets and the rules. Use the range like 1-10 or 1-100

# Define Boundires of the minimum and maximum for a character sheet in the appropriate game system.
# Otherwise default to 0/10
var systemSheetMin = 0
var systemSheetMax = 100

# Define Dice Type used by the desired module
# Otherwise default to a polyhedral set of dice.
var definedDiceTypes = [20,12,10,100,8,6,4]

# Define Level Boundries to be used by the character of the current level
# Otherwise default to 0/100
var defineMinLevel = 0
var definedMaxLevel = 100


# Stats, Default Values are 50 percent:

# Physical Attributes (Stats):
# 1. AG = Agility
var Agility = 0.50
# 2. APP = Appearance
var Appearance = 0.50
# 3. CO = Constitution
var Constitution = 0.50
# 4. QU = Quickness
var Quickness = 0.50
# 5. MD = Manual Dexterity
var ManualDexterity = 0.50
# 6. ST = Strength
var Strength = 0.50

# Non-physical Attributes (Stats):
# 7. CH = Chutzpah
var Chutzpah = 0.50
# 8. EM = Empathy
var Empathy = 0.50
# 9. IN = Intuition
var Intuition = 0.50
# 10. ME = Memory
var Memory = 0.50
# 11. MX = Moxie
var Moxie = 0.50
# 12. PR = Presence
var Presence = 0.50
# 13. RE = Reasoning
var Reasoning = 0.50
# 14. SD = Self Discipline
var SelfDiscipline = 0.50



#Skills: Default Values are Zero Percent

var Athletics = 0.0

var Communication = 0.0

var Knowledge = 0.0

var Magical = 0.0

var Mechanical = 0.0

var MovingAndManeuvering = 0.0

var PerceptiveAndObservational = 0.0

var Stealth = 0.0

var SocialInteractions = 0.0

var Weapons = 0.0

# TODO: Add Modifers to the characters sheet: Then these modfiers can be added to skill checks

# Section 1 End

#Section 2 (Calculate)
# Need to find what formulas and problems we need to solve as a part of section 2

func _ready():
	pass

# Define process for declareing actions
# Otherwise follow the rough "Doctor Who" action process.
func _declareAction():
	pass

func nonOpposedSkillCheck(requiredStat, numberToMatch, statModifier = 0.0):
# Luke
# Last Modified: 1/21/2023
# Grab the skill and compare it to the required number for a "good roll"
# Think of the checks in Dialog in Fallout 3 and New Vegas
# The default modifier is Zero, unless another stat modifier value is provided
	
#	Stat modifier should come from the character sheet.
	if statModifier > 0.0:
		var moddedStat = requiredStat + statModifier
		if moddedStat >= numberToMatch:
			return true
		else:
			return false
	else: 
		if requiredStat >= numberToMatch:
			return true
		else:
			return false


# Refactor DieRoller from the main game, to be a modular function
# Pull Die Sizes from the variable "definedDiceTypes"
func _dieRoll(dieMin, dieMax):
	return randi() % dieMax + dieMin

# Create rough formulas to plug into this function, per game system module
# Otherwise follow the default formula provided in the function
func _calculateInitiative(inputCharacterArray):
	var outputCharacterArray = []
	for person in inputCharacterArray:
#		Return a number between 1 / 20 and add it to the array
#		Change to a D6 for BFRPG rules.
		outputCharacterArray.push_back([person, _dieRoll(1, 20)])
		
#		Sort by highest to lowest, according to BFRPG Rules.
		outputCharacterArray.sort()

		
	return outputCharacterArray


# Draft Function
# Need to work on calculate initiatve first.
# I might need to have to add a way to resolve Ties between both arrays.
func _defenderAndOpponentResults(playerArray, enemyArray):
	var DefenderResults = []
	var OpponentResults = []

	DefenderResults.push_back(_calculateInitiative(playerArray))
	OpponentResults.push_back(_calculateInitiative(enemyArray))
	
	return[[DefenderResults][OpponentResults]]


# Section 2 End


# Things to add to the GSAL


# What do these two variables do? That was not clearly defined in the UML...
# var Action_Declared : Array
#
# var Situation_Mod : int
#
# What is the desired data that we want from these two Int values below
# var Defender_Results_Calculation : int
#
#var Opponent_Results_Calclation: int


#func _Outcome_Options(Matrix): List

