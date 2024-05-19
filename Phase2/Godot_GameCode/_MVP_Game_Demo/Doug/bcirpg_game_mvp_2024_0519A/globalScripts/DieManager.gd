#This is the diemanager script that controls the rolling of the die/dice as well as calculates
#the end result

class_name DieManager

extends Node2D

#Array of the desired dice values to mod god wants
var desiredDice: Array

#User can select the percentage needed for a successful roll
var neededPercentageToPass: float

var validDieTypes = [4, 6, 8, 10, 12, 20]
#boolean for if a percentageroll is taking place
#we need a boolean for this because the way a percentage roll is calculated
#with two D10s is different than if one were using other dice
var isPercentageRoll = false

#diceUsed holds the dice objects that are rolled
var diceUsed = []

#rolledValues holds the integer value rolled from each die
var rolledValues = []

#boolean based on whether the overall roll passed or not
var passedRoll

#float holding the degree of success (rolledVal - neededPercentageToPass)
var degreeOfSuccess

#Constructor for diemanager class
func _init(dice, percent):
	desiredDice = dice
	neededPercentageToPass = percent
	loadData()

#set values of diemanager
func setDieManager(dice, percent):
	desiredDice = dice
	neededPercentageToPass = percent
	loadData()
	
#Load the diceInPlay array
func loadData():
	for elem in desiredDice:
		if int(elem) in validDieTypes:
			diceUsed.append(Die.new(int(elem)))
	
	#conditional to check if two D10s are being used
	#if so, we know that a percentage roll is taking place
	#if len(desiredDice) == 2 && desiredDice[0] == 10 && desiredDice[1] == 10:
	#	isPercentageRoll = true
	#DKM TEMP: this is crashing 4/21/24 with strings coming through unchecked. Not sure what happened to the check that 
	#	was functional here before. TODO on this is type-safe this DieRoller entirely.
	if desiredDice.size() == 2 && int(desiredDice[0]) == 10 && int(desiredDice[1]) == 10:
		isPercentageRoll = true

#Resets the data in the script
func clearData():
	isPercentageRoll = false
	rolledValues = []
	desiredDice = []
	diceUsed = []
	neededPercentageToPass = 0
	
#Returns the percent value of an individual die
#Stores the rolled value in rolledValues
func returnDiePercentage(inputedDie):
	#In case this method is being called on no dice
	if len(diceUsed) == 0:
		push_error("Cannot roll without any dice!")
		
	var rolledVal = inputedDie.rollDie()
	
	#add rolled integer value to array
	rolledValues.append(rolledVal)
	
	#Checks if a percentageroll is being done
	if isPercentageRoll:
		#This conditional is used to detemrine if the rolled value is
		#for the tens or ones digit
		return float(rolledVal % 10)
	
	return float(rolledVal) / float(inputedDie.numFaces)

#Rolls all of the dice in diceUsed
#returns the average of all the percentages
func rollDice():
	#In case this method is being called on no dice
	if len(diceUsed) == 0:
		push_error("Cannot roll without any dice!")
		
	#denominator will equal the total number of dice rolled
	var denominator = 0
	
	#sum of floats of all rolled die percentages
	var sumOfPercentages = 0
	
	if isPercentageRoll:
		sumOfPercentages += (returnDiePercentage(diceUsed[0]) / 10.0) + (returnDiePercentage(diceUsed[1]) / 100.0)
	else:
		#DKM TEMP: not percentage roll:
		print("TEMP: not percentage roll")
		for die in diceUsed:
			sumOfPercentages += returnDiePercentage(die)
			denominator += 1
			
	var result = []

	result.append(rolledValues)
	
	if isPercentageRoll:
		#Percentage roll result remains the sum of the rolls
		result.append(sumOfPercentages)
	else:
		if denominator == 0:
			result.append(0)
		#result is average of sum of percentages otherwise rounded to 2 decimcal places
		
		result.append(stepify((float(sumOfPercentages) / float(denominator)), 0.0001))
		
	passedRoll = (result[1] >= neededPercentageToPass)
#NOTE: degree of success is always calculated regardlesss of success/failure. Let me know if this should be changed	
	degreeOfSuccess = result[1] - neededPercentageToPass
	result.append(passedRoll)
	result.append(neededPercentageToPass)
	result.append(degreeOfSuccess)
	result.append(desiredDice)
	
	#rollDice result: [[rolledValues], percentRolled, passResult, neededPercent, degreeOfSuccess, dice]
	return result

	
