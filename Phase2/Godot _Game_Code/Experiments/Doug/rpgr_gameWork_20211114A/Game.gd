extends Control

#Abstract class we instance when wanted in game as child of HistoryReference
const InputResponse = preload("res://UserInterface/InputResponse.tscn")
#Limit the length of our history:
var max_scroll_length := 0

onready var history_rows = $Background/MarginContainer/Rows/GameInfo/ScrollContainer/HistoryRows
onready var scroll = $Background/MarginContainer/Rows/GameInfo/ScrollContainer
onready var scrollbar = scroll.get_v_scrollbar()

#Ensure that the latest added input is in focus on scroll
func _ready() -> void:
		scrollbar.connect("changed", self, "handle_scrollbar_changed")
		max_scroll_length = scrollbar.max_value
		
func handle_scrollbar_changed():
	if max_scroll_length != scrollbar.max_value:
		max_scroll_length = scrollbar.max_value
		scroll.scroll_vertical = max_scroll_length		

#Below temporarily takes user selection and appends it to responses; adding new isntances 
#	of our input row with an input and response pair for each
func handleUserInput(user_choice: String) -> void:
	var input_response = InputResponse.instance()
	var inputText = "User selected: " + user_choice
	var response = "Game text output for " + user_choice
	input_response.set_text(inputText, response)
	history_rows.add_child(input_response)

func _on_option1_button_down() -> void:
	handleUserInput("Option 1")

func _on_option2_button_down() -> void:
	handleUserInput("Option 2")

func _on_option3_button_down() -> void:
	handleUserInput("Option 3")
