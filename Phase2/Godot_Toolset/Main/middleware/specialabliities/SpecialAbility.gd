extends Node

#This class, is used to define special ability data. Such as for attacks like shooting fireballs.
#This is the middle ware, to define the structure of the data, before it is accesable by the character sheet.
#This class is also used to define the structure, as to make it normalized for the database / XML layers.

# Luke, 12/10/2023, Godot 3.5+

func create_ability(AbilityName: String, Attribute: Array, Cost: int, Damage: int, 
LevelRequirement: int, Duration: float, AffectedAttribute: String,
DiceRules: Vector3) -> Dictionary:
	var data = {
		"AbilityName": AbilityName,
		"Attribute": Attribute,
		"Cost": Cost,
		"Damage": Damage,
		"LevelRequirement": LevelRequirement,
		"Duration": Duration,
		"AffectedAttribute": AffectedAttribute,
		"DiceRules": DiceRules,
	  }
	return data
