#BUT_HISTORY_PAGE:
#	Unique paging script for showing next page in the history game's history 
#		array. 


tool
extends Button

onready var game_history_array = get_node("/root/History").historyScreensSingleton.output_history_array
#DKM TEMP: conversion to global -- prior method
#onready var game_history_array = get_node("../../../../../").history_array

var current_page = 0

func _on_But_History_Page_button_up():
	var history_rows_node = get_node("../../GameInfo/HistoryRows")
	if(current_page < game_history_array.size()-1):
		current_page += 1
	else:
		current_page = 0
	history_rows_node.remove_child(history_rows_node.get_child(0)) 
	history_rows_node.add_child(game_history_array[current_page])

