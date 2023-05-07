extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	print(checkAndCorrectGrammar("A unicorn is a mythical creature"))
	print(checkAndCorrectGrammar("An apple a day keeps the doctor away"))
	print(checkAndCorrectGrammar("An house on the hill."))
	print(checkAndCorrectGrammar("A egg a day is unhealthy."))
	print(checkAndCorrectGrammar("An unique idea."))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func checkAndCorrectGrammar(str: String) -> String:
	var vowels: Array = ["a", "e", "i", "o", "u"]
	var words: Array = str.split(" ")
	var correctedStr: String = ""
	
	for word in words:
		var firstChar: String = word[0].to_lower()
		if firstChar in vowels:
			if word.substr(0, 2).to_lower() != "an":
				word = "an " + word
				print("Changed \"" + word + "\" to \"" + "an " + word + "\"")
			else:
				print("Kept \"" + word + "\"")
			correctedStr += word + " "
		else:
			if word.substr(0, 1).to_lower() != "a":
				if word.substr(1, 1) == "n":
					word = word.substr(2, word.length())
					print("Changed \"" + word + "\" to \"" + "a " + word + "\"")
				else:
					word = "a " + word
					print("Changed \"" + word + "\" to \"" + "a " + word + "\"")
			else:
				print("Kept \"" + word + "\"")
				correctedStr += word + " "

	return correctedStr.strip_edges()
