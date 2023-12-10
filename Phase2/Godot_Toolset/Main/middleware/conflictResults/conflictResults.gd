extends Object

class_name ConflictResultsProcess

#This class is used to define the player and NPC order in combat. Also called Initiative in some game systems.
#Rough Draft: 12/3/2023: Luke, Godot 3.5

#How are we calculating initiatve. Are we going to pull the formula from the GSAL?
var Initiative_Order : Array

#What do these two variables do? That was not clearly defined in the UML...
var Action_Declared : Array
	
var Situation_Mod : int

# What is the desired data that we want from these two Int values below
var Defender_Results_Calculation : int

var Opponent_Results_Calclation: int

func _init():
	pass
	
#func _Defender_VS_Opponent_Results(int): Matrix
#Matrix is not a built in datatype in Godot. How I am imagining us doing this is with a 2D or 3D array.
#Example Structure [[DefenderResults], [OpponentResults]]


#func _Outcome_Options(Matrix): List
