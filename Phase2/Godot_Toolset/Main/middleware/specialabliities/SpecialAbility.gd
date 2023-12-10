extends Object

#This class, is used to define special ability data. Such as for attacks like shooting fireballs.
#This is the middle ware, to define the structure of the data, before it is accesable by the character sheet.
#This class is also used to define the structure, as to make it normalized for the database / XML layers.

# Luke, 12/10/2023, Godot 3.5+
	
	
var Name: String

var Attribute: Array

var Cost: int

var Damage: int

var LevelRequirement: int

var Duration: float

var AffectedAttribute: String

var DiceRules: Vector3

func _init(initName: String, initAttribute: Array, initCost: int, initDamage: int, 
initLevelRequirement: int, initDuration: float, initAffectedAttribute: String,
initDiceRules: Vector3):
	
	Name = initName
#	Attribute = initAttribute
	Cost = initCost
	Damage = initDamage
	LevelRequirement = initLevelRequirement
	Duration = initDuration
	AffectedAttribute = initAffectedAttribute
	DiceRules = initDiceRules
	
	Attribute = []
	for element in initAttribute:
		if typeof(element) == TYPE_STRING:
			Attribute.append(element)
		else:
			print("Warning: Ignoring non-string element in StringArray.")

# Custom method to convert the object to a string
func to_string() -> String:
	return "SpecialAbility(Name: {Name}, Attribute: {Attribute}, Cost: {Cost}, Damage: {Damage}, LevelRequirement: {LevelRequirement}, Duration: {Duration}, AffectedAttribute: {AffectedAttribute}, DiceRules: {DiceRules})"
