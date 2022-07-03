#Die class

extends Button

class_name Die

#array of valid number of faces
var dieTypes = [4, 6, 8, 10, 12, 20]

#value of selected die type
var numFaces: int

#bool will be used to check if a valid die type was chosen
var validNumFaces = false

#Class constructor
func _init(value):
	numFaces = value

#returns an integer value of the rolled result (assuming the die is a valid type)
func rollDie():
	randomize()
	
	#check if selected die type exists in dieTypes array
	for value in dieTypes:
		if value == numFaces:
			validNumFaces = true
	
	#if the selected die type exists, we can roll an integer value based on the number of sides.
	if validNumFaces:
		var rolledNum
		rolledNum = randi() % numFaces + 1
		return rolledNum
	else:
		print("You do not have a valid number of sides on the die!")
		return
		
		
