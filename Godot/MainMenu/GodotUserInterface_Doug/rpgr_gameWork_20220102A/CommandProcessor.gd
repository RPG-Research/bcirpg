extends Node


var current_locale = null
var current_opt1 = null
var current_opt2 = null
var current_opt3 = null

#Allows us to pass in the starting location
func initialize(starting_locale) -> String:
	current_opt1 = get_node("../Background/MarginContainer/Rows/InputArea/VBoxContainer/option1")
	current_opt2 = get_node("../Background/MarginContainer/Rows/InputArea/VBoxContainer/option2")
	current_opt3 = get_node("../Background/MarginContainer/Rows/InputArea/VBoxContainer/option3")
	
	current_opt1.grab_focus()
	return change_room(starting_locale)

#Function that loads response from the option string chosen
func process_command(option: String) -> String:
	var optionArr = option.split(" ", false)
	if optionArr.size() < 2:
			return "Error: no valid command in option!"
	if(optionArr[0] == "Go"):
		return go(optionArr[1])
	else:
		return "Nothing happens! Command word was: " + optionArr[0]
		
func go(destination: String) -> String:
	if current_locale.exits.keys().has(destination):
		var change_response = change_room(current_locale.exits[destination])
		return PoolStringArray(["You go %s." % destination, change_response]).join("\n")
	else:
		return "That is not a valid place to go!"			
		
#DKM TEMP: string outputter
func optionResponse(optInt: int) -> String:
	if(optInt == 1):
		return "First option leads you down a hallway!"
	if(optInt == 2):
		return "Second option drops you in a pit!"
	else:
		return "Third option leads you to a hallway full of great food!"	

#Helper:
func change_room(new_room: Locale) -> String:
	current_locale = new_room
	current_opt1.text = new_room.option1
	current_opt2.text = new_room.option2
	current_opt3.text = new_room.option3
	var exit_string = PoolStringArray(new_room.exits.keys()).join(" ")
	var strings = PoolStringArray([
		"You are now in: " + new_room.locale_name + ". " + 
		new_room.locale_description, 
		"Exits: " + exit_string
	]).join("\n")
	return strings;
