extends Node
class_name Die


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
	rng.randomize()
	
	var NoOfSides = NumberOfFaces
	
	match NoOfSides:
		100:
			LowestPossibleNumberOnDie = 1
			DieFaceResult = rng.randi_range(LowestPossibleNumberOnDie, 10)
			DieFaceResult *= 10
			
		_:
			LowestPossibleNumberOnDie = 1
			DieFaceResult = rng.randi_range(LowestPossibleNumberOnDie, NumberOfFaces)
	
	var DieSuccessPercentage = (float(DieFaceResult)/float(NumberOfFaces))
	
	print("DieFace:")
	print(DieFaceResult)
	print("Die Success Rate")
	print(DieSuccessPercentage)

func SetNumberOfSides():
	var DSides = DieType

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
	DieType = DieCategory.D00
	SetNumberOfSides()
	RollDie(NumberOfFaces)
