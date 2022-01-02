extends Control

#Abstract class we instance when wanted in game as child of HistoryReference
const TextOutput = preload("res://UserInterface/Response.tscn")
const InputResponse = preload("res://UserInterface/InputResponse.tscn")
#Limit the length of our history:
var max_scroll_length := 0

onready var command_processor = $CommandProcessor
onready var history_rows = $Background/MarginContainer/Rows/GameInfo/ScrollContainer/HistoryRows
onready var scroll = $Background/MarginContainer/Rows/GameInfo/ScrollContainer
onready var scrollbar = scroll.get_v_scrollbar()
onready var locale_manager = $LocaleManager

#Ensure that the latest added input is in focus on scroll
func _ready() -> void:
	scrollbar.connect("changed", self, "handle_scrollbar_changed")
	max_scroll_length = scrollbar.max_value
	
	create_response("The game has begun! You can select from the available options below.")	

	var starting_locale_response = command_processor.initialize(locale_manager.get_child(0))
	create_response(starting_locale_response)
		
		
func handle_scrollbar_changed():
	if max_scroll_length != scrollbar.max_value:
		max_scroll_length = scrollbar.max_value
		scroll.scroll_vertical = max_scroll_length		

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
	history_rows.add_child(response)


func _on_option1_button_down() -> void:
	var option1 = get_node("Background/MarginContainer/Rows/InputArea/VBoxContainer/option1")
	handleUserInput(option1.get_text())


func _on_option2_button_down() -> void:
	var option2 = get_node("Background/MarginContainer/Rows/InputArea/VBoxContainer/option2")
	handleUserInput(option2.get_text())


func _on_option3_button_down() -> void:
	var option3 = get_node("Background/MarginContainer/Rows/InputArea/VBoxContainer/option3")
	handleUserInput(option3.get_text())
