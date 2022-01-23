tool
extends Button

onready var game_history_array = get_node("../../../../../").history_array

var is_history = false


func _on_But_History_button_up():
	var history_pager_button = get_node("../../ItemList/But_History_Page")
	var history_rows_node = get_node("../../GameInfo/HistoryRows")
	var current_text_node = get_node("../../GameInfo/CurrentText")
	var option_one = get_node("../../InputArea/VBoxContainer/option1")
	var option_two = get_node("../../InputArea/VBoxContainer/option2")
	var option_three = get_node("../../InputArea/VBoxContainer/option3")
		
	if(!is_history):
		history_rows_node.add_child(game_history_array[0])
		history_pager_button.show()
		history_rows_node.show()
		current_text_node.hide()
		option_one.hide()
		option_two.hide()
		option_three.hide()
		is_history = true
	else:
		history_pager_button.hide()
		history_rows_node.hide()
		current_text_node.show()
		option_one.show()
		option_two.show()
		option_three.show()
		is_history = false
	
