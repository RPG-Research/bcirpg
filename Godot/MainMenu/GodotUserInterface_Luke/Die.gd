extends Node
class_name Die

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum DieCategory{
	D4,
	D6,
	D8,
	D10,
	D12,
	D00,
	D20	
}

var dieType = DieCategory
var numberOfFaces = 0

func SetNumberOfSides():
	var DSides = dieType
	

	match DSides:
		D4:
			numberOfFaces = 4
		D6:
			numberOfFaces = 6
		D8:
			numberOfFaces = 8
		D10:
			numberOfFaces = 10
		D12:
			numberOfFaces = 12
		D00:
			numberOfFaces = 100
		D20:		
			numberOfFaces = 20


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
