extends Node

# Section 1 (Define Ruleset)
# Work of a precentage for the character sheets and the rules. Use the range like 1-10 or 1-100

# Define Boundires of the minimum and maximum for a character sheet in the appropriate game system.
# Otherwise default to 0/10
var systemSheetMin = 0
var systemSheetMax = 10


# Define Dice Type used by the desired module
# Otherwise default to a polyhedral set of dice.
var definedDiceTypes = [20,12,10,100,8,6,4]


# Define Level Boundries to be used by the character of the current level
# Otherwise default to 0/100
var defineMinLevel = 0
var definedMaxLevel = 100

# Section 1 End


#Section 2 (Calculate)
# Need to find what formulas and problems we need to solve as a part of section 2

func _ready():
	pass


# Define process for declareing actions
# Otherwise follow the rough "Doctor Who" action process.
func _declareAction():
	pass


# Refactor DieRoller from the main game, to be a modular function
# Pull Die Sizes from the variable "definedDiceTypes"
func _dieRoll():
	pass


# Create rough formulas to plug into this function, per game system module
# Otherwise follow the default formula provided in the function
func _calculateInitiative():
	pass


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

#func _Defender_VS_Opponent_Results(int): Matrix
#Matrix is not a built in datatype in Godot. How I am imagining us doing this is with a 2D or 3D array.
#Example Structure [[DefenderResults], [OpponentResults]]


#func _Outcome_Options(Matrix): List

