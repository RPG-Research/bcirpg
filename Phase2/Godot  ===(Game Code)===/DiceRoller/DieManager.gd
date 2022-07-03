#This is the diemanager script that controls the rolling of the die/dice as well as calculates
#the end result

extends Control

export var desiredDice = [20, 8]

var validDieTypes = [4, 6, 8, 10, 12, 20]


#boolean for if a percentageroll is taking place
#we need a boolean for this because the way a percentage roll is calculated
#with two D10s is different than if one were using other dice
var isPercentageRoll = false

#diceUsed holds the dice objects that are rolled
var diceUsed = []

#diceInPlay holds the die objects as well.
#This and diceUsed are essentially the same arrays (holding the dice objects), but I had to use
#two arrays due to the parameters in returnDiePercentage
var diceInPlay = []

#rolledValues holds the integer value rolled from each die
var rolledValues = []

#User can select the percentage needed for a successful roll
export var neededPercentageToPass = .2

#boolean based on whether the overall roll passed or not
var passedRoll

#float holding the degree of success (rolledVal - neededPercentageToPass)
var degreeOfSuccess


#Load the diceInPlay array
func _ready():
	for elem in desiredDice:
		if elem in validDieTypes:
			diceInPlay.append(Die.new(elem))
	
	#conditional to check if two D10s are being used
	#if so, we know that a percentage roll is taking place
	if len(desiredDice) == 2 && desiredDice[0] == 10 && desiredDice[1] == 10:
		isPercentageRoll = true
			
	

#This is the function that returns the percentage of a rolled die (rolled val / total sides)
#The UML showed that this function only had one parameter, "inputedDie," so I assumed that
#was the rolled integer value. However, in order to find the percetage we need the total sides as well
#As a result, I would get the total sides by ensuring that the inputedDie corresponds to the die at index 0
#of the diceInPlay array.   
func returnDiePercentage(inputedDie):
	
	var totalSides = diceInPlay[0].numFaces
	
	#ensuring we don't lose the die objects in memory by storing them in another array
	diceUsed.append(diceInPlay[0])
	diceInPlay.remove(0)
	
	#Checks if a percentageroll is being done
	if isPercentageRoll:
		
		#This conditional is used to detemrine if the rolled value is
		#for the tens or ones digit
		if (len(diceUsed) == 1):
			return float(inputedDie % 10) / 10.0
		else:
			return float(inputedDie % 10) / 100.0
	
	var result = float(inputedDie) / float(totalSides)
	return result
	

#Function to show all of the results on screen
func showOnUI(passResult, percentRolled) -> void:
	if passResult:
		$Outcome.text = "Successful Roll!"
	else:
		$Outcome.text = "Failed Roll!"
	
	var diceResultText = "Rolled Values:\n"
	
	#Prints the integer calues of each die rolled in the form: "D(num faces): (value rolled)"
	for i in range(diceUsed.size()):
		diceResultText += ("D" + str(diceUsed[i].numFaces) + ": " + str(rolledValues[i]) + "\n")
	
	
	#NOTE: degree of success is always calculated regardlesss of success/failure. Let me know if this should be changed
	degreeOfSuccess = percentRolled - neededPercentageToPass
	
	#changing labels on screen
	$RolledValues.text = diceResultText
	$PercentNeeded.text = "Percent Needed to Pass: " + str(neededPercentageToPass * 100) + "%"
	$PercentRolled.text = "Percent Rolled: " + str(percentRolled * 100) + "%"
	$DegreeOfSuccess.text = "Degree of Success: " + str(degreeOfSuccess * 100) + "%"
	
	#revealing labels to user
	$Outcome.show()
	$RolledValues.show()
	$PercentNeeded.show()
	$PercentRolled.show()
	$DegreeOfSuccess.show()
		

#function for when "roll" button is clicked
func _on_Die_button_down():
	#denominator will equal the total number of dice rolled
	var denominator = 0
	
	#sum of floats of all rolled die percentages
	var sumOfPercentages = 0
	
	#stores the rolled integer value of die in loop
	var rolledVal
	
	#remember that the size of diceInPlay decrements by 1 each time returnDiePercentage is called
	while diceInPlay.size() > 0:
		rolledVal = diceInPlay[0].rollDie()
		
		#add rolled integer vaslue to array
		rolledValues.append(rolledVal)
		
		#add percentage to sum
		sumOfPercentages += returnDiePercentage(rolledVal)
		
		#increment denominator
		denominator += 1
	
	var result
	if isPercentageRoll:
		#Percentage roll result remains the sum of the rolls
		result = sumOfPercentages
	else:
		#result is average of sum of percentages otherwise
		result = sumOfPercentages / denominator		
	
	passedRoll = (result >= neededPercentageToPass)
	
	showOnUI(passedRoll, result)
	return result


#Reset stored values and text
func _on_Reset_pressed():
	$Outcome.hide()
	$PercentNeeded.hide()
	$PercentRolled.hide()
	$DegreeOfSuccess.hide()
	$RolledValues.hide()
	
	#Fill diceInPlay again and empty diceUsed
	for die in diceUsed:
		diceInPlay.append(die)
	diceUsed = []
	rolledValues = []
