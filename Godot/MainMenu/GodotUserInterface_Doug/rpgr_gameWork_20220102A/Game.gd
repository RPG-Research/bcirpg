extends Control

#Abstract class we instance when wanted in game as child of HistoryReference
const TextOutput = preload("res://UserInterface/Response.tscn")
const InputResponse = preload("res://UserInterface/InputResponse.tscn")

#TODO: offload this to file
#For storing history selections 
var output_history_singleton = OutputHistory.new()
var history_array = output_history_singleton.output_history_array

#TODO: change 'HistoryRows' to better name for current use
var history_screens_array = Array()

onready var command_processor = $CommandProcessor
onready var current_text = $Background/MarginContainer/Rows/GameInfo/CurrentText
onready var history_rows = $Background/MarginContainer/Rows/GameInfo/HistoryRows
onready var history_pager = $Background/MarginContainer/Rows/ItemList/But_History_Page
onready var locale_manager = $LocaleManager
onready var option_one = $Background/MarginContainer/Rows/InputArea/VBoxContainer/option1
onready var option_two= $Background/MarginContainer/Rows/InputArea/VBoxContainer/option2
onready var option_three = $Background/MarginContainer/Rows/InputArea/VBoxContainer/option3


func _ready() -> void:
	history_pager.hide()
	history_rows.hide()
	current_text.show()
	option_one.show()
	option_two.show()
	option_three.show()

	create_response("The game has begun! You can select from the available options below.")	

	var starting_locale_response = command_processor.initialize(locale_manager.get_child(0))
	create_response(starting_locale_response)	

#Below temporarily takes user selection and appends it to responses; adding new isntances 
#	of our input row with an input and response pair for each
func handleUserInput(user_choice: String) -> void:
	var input_response = InputResponse.instance()
	var inputText = "User selected: " + user_choice
	var response = command_processor.process_command(user_choice)
	input_response.set_text(inputText, response)
	add_response_to_game(input_response)
	
	
func create_response(response_text: String):
	var response = TextOutput.instance()
	response.text = response_text
	add_response_to_game(response)	


func add_response_to_game(response: Control):
	var response_history = response.duplicate()
	history_array.append(response_history)
	current_text.remove_child(current_text.get_child(0))
	current_text.add_child(response)


func _on_option1_button_down() -> void:
	var option1 = get_node("Background/MarginContainer/Rows/InputArea/VBoxContainer/option1")
	handleUserInput(option1.get_text())


func _on_option2_button_down() -> void:
	var option2 = get_node("Background/MarginContainer/Rows/InputArea/VBoxContainer/option2")
	handleUserInput(option2.get_text())


func _on_option3_button_down() -> void:
	var option3 = get_node("Background/MarginContainer/Rows/InputArea/VBoxContainer/option3")
	handleUserInput(option3.get_text())
