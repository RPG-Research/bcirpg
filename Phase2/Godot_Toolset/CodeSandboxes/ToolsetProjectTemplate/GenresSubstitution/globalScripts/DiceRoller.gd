#This script is for the overarching node that will contain the diemanager singleton
#It should be the only one of the die scripts that is attached onto a node.

extends Control

#desired dice types and needed percentage to pass are selected by game/user
#desiredDice takes an int array representing the # sides on the die/dice
#neededPercentageToPass takes a float that
export var desiredDice: Array
export var neededPercentageToPass: float

#Define dieManager variable
var dieManager

func _ready():
	#create diemanager object
	dieManager = DieManager.new(desiredDice, neededPercentageToPass)

#function gets the result of the roll(s) and shows it in the UI
func _on_Die_button_down():
	#rollDice function returns an array with the following elements in the following positions:
	#rollDice result: [[rolledValues], percentRolled, passResult, neededPercent, degreeOfSuccess, dice]
	var result = dieManager.rollDice()
	
	
	#assigning variable names to each of them for better clarity
	var rolledValues = result[0]
	var percentRolled = result[1]
	var passResult = result[2]
	var neededPercent = result[3]
	var degreeOfSuccess = result[4]
	var dice = result[5] 
	
	
	#Check if passed or not
	if passResult:
		$Outcome.text = "Successful Roll!"
	else:
		$Outcome.text = "Failed Roll!"

	var diceResultText = "Rolled Values:\n"

	#Prints the integer calues of each die rolled in the form: "D(num faces): (value rolled)"
	for i in range(dice.size()):
		diceResultText += ("D" + str(dice[i]) + ": " + str(rolledValues[i]) + "\n")

	#changing labels on screen
	$RolledValues.text = diceResultText
	$PercentNeeded.text = "Percent Needed to Pass: " + str(neededPercent * 100) + "%"
	$PercentRolled.text = "Percent Rolled: " + str(percentRolled * 100) + "%"
	$DegreeOfSuccess.text = "Degree of Success: " + str(degreeOfSuccess * 100) + "%"

	#revealing labels to user
	$Outcome.show()
	$RolledValues.show()
	$PercentNeeded.show()
	$PercentRolled.show()
	$DegreeOfSuccess.show()
	
	
#Calls the cleardata method for the diemanager and hides the text on screen
func _on_Reset_button_down():
	$Outcome.hide()
	$PercentNeeded.hide()
	$PercentRolled.hide()
	$DegreeOfSuccess.hide()
	$RolledValues.hide()
	dieManager.clearData()
	dieManager.setDieManager(desiredDice, neededPercentageToPass)
