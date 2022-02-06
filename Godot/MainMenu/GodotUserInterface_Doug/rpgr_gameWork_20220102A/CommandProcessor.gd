#COMMAND PROCESSOR: 
# Handles player input, including navigation on the map

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

#DKM TEMP: this must load from files written by toolset
#Function that loads response from the option string chosen
func process_command(option: String) -> String:
	var optCmd_Action = option.split(": ", false)
	if (optCmd_Action.size() < 2):
		return "Error: no valid command and action in option!"
	match optCmd_Action[0]:
		"Go":
			return go(optCmd_Action[1])
		"Wait":
			return "You rest a bit.  Now what?"
		"Talk":
			return talk(optCmd_Action[1])
		"Examine":
			return examine(optCmd_Action[1])
		"Scream":
			return "You yell :'" + optCmd_Action[1].to_upper() +"'!!"
		_:	
			return "Nothing happens! Command word was: " + optCmd_Action[0]
		
		
		
func go(action: String) -> String:
	var destination = action.split(" ", false)[0]
	if current_locale.exits.keys().has(destination):
		var change_response = change_room(current_locale.exits[destination])
		return PoolStringArray(["You go %s." % destination, change_response]).join("\n")
	else:
		return "That is not a valid place to go!"			
		
#DKM TEMP: do an examination dictionary lookup here?
func examine(action: String) -> String:
	return action.to_upper() + " looks about how you'd expect. [Dictionary lookup forthcoming]"
		
#DKM TEMP: dialog entry needed -- temp
func talk(action: String) -> String:
	var target = action.split("to ", false)[0].to_upper()
	return target + " has little to say! [Dialog forthcoming]"

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
