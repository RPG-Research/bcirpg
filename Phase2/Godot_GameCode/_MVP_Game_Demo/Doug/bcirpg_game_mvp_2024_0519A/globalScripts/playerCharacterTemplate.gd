#PLAYER CHARACTER TEMPLATE:
#	Template for holding loaded/current character 

extends Resource

class_name playerCharacterTemplate

var pcText = ""
 
var name = ""

var profession = ""

var strength = ""

var intellect = ""

var willpower = ""

var charm = ""

var weapon = ""

var armor = ""

var quote = ""


func _print_PC():
	pcText="NAME: " + name + "\n" \
	+ "PROF: " + profession + "\n" \
	+ "STR: " + strength + "\n" \
	+ "INT: " + intellect + "\n" \
	+ "WILL: " + willpower + "\n" \
	+ "CHR: " + charm + "\n" \
	+ "WEAPON: " + weapon + "\n" \
	+ "ARMOR: " + armor + "\n" \
	+ "QUOTE: " + quote
