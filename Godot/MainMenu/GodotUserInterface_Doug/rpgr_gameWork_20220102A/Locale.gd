#LOCALE CLASS:
# Template script for the Locale scene; allows for connecting exits, and also
#	maintains a visited bool (currently un-used) and takes additional
#	options via the GUI:
#	1. Name
#	2. Description
#	3. The 3 option strings available at the location 
#


extends PanelContainer
#Allows Godot to handle autocomplete and 'register' class
class_name Locale

export (String) var locale_name = "Location Name"
export (String) var locale_description = "This is the description of the location."

#DKM TEMP: assuming this gets set here
export (String) var option1 = "Option 1"
export (String) var option2 = "Option 2"
export (String) var option3 = "Option 3"

var visited = false;

var exits: Dictionary = {}

#DKM TEMP: right now connects both directions, but can make an alt func that c
#	connects just one way for example (for one-way-doors)
#	currently not in use, but the override defaults false but if passed can let 
#	you apply custom direction
func connect_exit(direction: String, locale: Locale, override_direction: bool = false):
	if(!override_direction):
		match direction:
			"west":
				exits[direction] = locale
				locale.exits["east"] = self
			"east":
				exits[direction] = locale
				locale.exits["west"] = self
			"north":
				exits[direction] = locale
				locale.exits["south"] = self
			"south":
				exits[direction] = locale
				locale.exits["north"] = self
			_:	
				printerr("Tried to connect invalid direction: %s", direction)
	else:
		exits[direction] = locale
