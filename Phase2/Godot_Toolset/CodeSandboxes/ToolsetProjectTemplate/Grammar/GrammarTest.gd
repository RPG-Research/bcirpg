extends Node2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



#rebuild_sentence is here to assist with making a human readable sentence, out of the array created in correct_sentence.
#Example of how to call this function from within another function:
#
#var outputString = rebuild_sentence(newWords)
#
#	return(outputString)	
	
func rebuild_sentence(input_sentance: Array) -> String:
	var outputString = ""
	for i in range(input_sentance.size()):
		outputString += input_sentance[i] + " "

	return outputString


#correct_sentances will output a modified string array, based on the sentance String that you input.
#
#Here is what is outputed from the following function calls.
#
#	print(correct_sentence("An unicorn is an mythical creature"))
#	print(correct_sentence("A apple a day keeps an doctor away"))
#	print(correct_sentence("An hour"))
#	print(correct_sentence("Eating seeds as an passtime activity..."))
#	print(correct_sentence("Wake Up... Grab an brush and put on a little makeup..."))
#
#	["A", "unicorn", "is", "a", "mythical", "creature"]
#	["A", "apple", "a", "day", "keeps", "a", "doctor", "away"]
#	["An", "hour"]
#	["Eating", "seeds", "as", "a", "passtime", "activity..."]
#	["Wake", "Up...", "Grab", "a", "brush", "and", "put", "on", "a", "little", "makeup..."]


func correct_sentence(input_string: String) -> String:
	var words = input_string.split(" ")
	var newWords = words
	var articleList = ["a", "an", "A", "An"]
	var exceptionsListForAn = ""
	var exceptionsListForA = ""
	var exceptionsList = ["hour"]

#	One Potential Addition, could be that we make an exception list for words that should be prefixed with A, and another one for words that should be prefixed with An

# 	Start Filtering the words
	for i in range(words.size()):
		var current_word = words[i]
		var first_character = current_word.substr(0, 1).to_lower()

#	Correct Every Word after the first word.
		if i > 1:
			var last_word = words[i-1]

			if current_word != last_word:
				if articleList.has(last_word):
					if first_character.match("[aeiouAEIOU]") or exceptionsList.has(last_word):
						newWords[i-1] = "an"
					else:
						newWords[i-1] = "a"

#	Correcting the first word of the string now.
		if words[0] != words[1]:
			if articleList.has(words[0]):
				var nextWordFirstChar = words[1].substr(0, 1).to_lower()
				if nextWordFirstChar.match("[aeiouAEIOU]") or exceptionsList.has(words[1]):
					newWords[0] = "An"
				else:
					newWords[0] = "A"

	var outputString = rebuild_sentence(newWords)
	
	return(outputString)


func _ready():
	print(correct_sentence("Eating seeds as an passtime activity..."))
