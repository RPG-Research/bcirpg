tool
extends Button

onready var history_rows = $Background/MarginContainer/Rows/GameInfo/ScrollContainer/HistoryRows
onready var current_text = $Background/MarginContainer/Rows/GameInfo/CurrentText

func _on_But_History_button_up():
	print("History button pressed - temp")
	
