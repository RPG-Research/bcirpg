#BUT_HISTORYPAGER:
# Simply moves through array page -- should call the HistoryViewer script to display 
# 	stored page and response fro the history array
#

extends Button

onready var historyViewerScript = get_node("/root/HistoryViewer")



func _on_But_HistoryPager_button_up() -> void:
	if(historyViewerScript.current_history_page_no < historyViewerScript.history_source.output_history_array.size()):
		historyViewerScript.current_history_page_no = historyViewerScript.current_history_page_no +1
	else:
		historyViewerScript.current_history_page_no = 0	
	print("Current page: " + str(historyViewerScript.current_history_page_no))
