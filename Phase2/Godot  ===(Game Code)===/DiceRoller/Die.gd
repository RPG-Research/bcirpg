#Die class

extends Button

class_name Die

#value of selected die type
var numFaces: int
#Class constructor
func _init(value):
	numFaces = value

#returns an integer value of the rolled result (assuming the die is a valid type)
func rollDie():
	randomize()
	
	var rolledNum
	rolledNum = randi() % numFaces + 1
	return rolledNum
		
		
