#BUT_HISTORYPAGER:
# Iterates the page number and calls HistoryViewer script to display 
# 	stored page and response fro the history array
#

extends Button

onready var historyViewerScript = get_node("/root/HistoryViewer")

#DKM TEMP: this needs refactoring -- too much being calculated as needed/repeated
func _on_But_HistoryPager_button_up() -> void:
	historyViewerScript.update_pager()
	
