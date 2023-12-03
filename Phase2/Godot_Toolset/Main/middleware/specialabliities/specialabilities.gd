extends Object

class_name SpecialAbility
#This class, is used to define special ability data. Such as for attacks like shooting fireballs.
#This is the middle ware, to define the structure of the data, before it is accesable by the character sheet.
#This class is also used to define the structure, as to make it normalized for the database / XML layers.

# Luke, 12/9/2023, Godot 3.5
	
	
var Name: String

#Add TypeCheck for arrays of only strings at some point.
var Attribute: Array

var Cost: int

var Damage: int

func _init(initName: String, initAttribute: Array, initCost: int, initDamage: int):
	Name = initName
	Attribute = initAttribute
	Cost = initCost
	Damage = initDamage
