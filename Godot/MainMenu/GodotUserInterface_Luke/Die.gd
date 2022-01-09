extends Node
class_name Die

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum DieCategory{
	D4 = 4,
	D6 = 6,
	D8 = 8,
	D10 = 10,
	D12 = 12,
	D00 = 00,
	D20 = 20	
}

var DieType = DieCategory
var NumberOfFaces = 0


func RollDie(InputDie):
	#InputDie is supposed to be DieType for example.
	var DieFaceResult = 0;
	var LowestPossibleNumberOnDie = 0
	var rng = RandomNumberGenerator.new()
	
	var NoOfSides = NumberOfFaces
	
	match NoOfSides:
		100:
			LowestPossibleNumberOnDie  = 0
			#Will need to come up with a solution just for 00 Dice.
	
		_:
			LowestPossibleNumberOnDie = 1
			DieFaceResult = rng.randi_range(LowestPossibleNumberOnDie, NumberOfFaces)
	
	var DieSuccessPercentage = DieFaceResult/NumberOfFaces
	
	print("DieFace:")
	print(DieFaceResult)


func SetNumberOfSides():
	var DSides = DieType
# For 7 Die Set, testing purposes	


########################################
# Need to Seed Random Number Generator #
########################################

	match DSides:
		4:
			NumberOfFaces = 4
		6:
			NumberOfFaces = 6
		8:
			NumberOfFaces = 8
		10:
			NumberOfFaces = 10
		12:
			NumberOfFaces = 12
		00:
			NumberOfFaces = 100
		20:		
			NumberOfFaces = 20
				
	print(NumberOfFaces)


# Called when the node enters the scene tree for the first time.
func _ready():
	DieType = DieCategory.D20
	SetNumberOfSides()
	RollDie(NumberOfFaces)
	# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
