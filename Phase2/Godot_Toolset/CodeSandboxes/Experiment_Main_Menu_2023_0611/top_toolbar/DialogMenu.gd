extends Label



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_save_button_pressed():
	var listOfTerms = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<genresettings>\n <gramarsettings>\n"
	var file = FileAccess.open("user://DialougeSettings.xml", FileAccess.WRITE)
	var fromFile = $VBoxContainer/OptionButton.get_children()
	for termset in fromFile:
		if termset is ScrollContainer:
			listOfTerms = listOfTerms + "\t<" + termset.name + ">\n"
			var group = termset.get_child(0)
			for term in group:
				if term is BoxContainer:
					listOfTerms = listOfTerms + "\t\t<term>\n\t\t\t<singular>\n\t\t\t\t" + term.get_child(0).get_child(1).text + "\n\t\t\t</singular>\n\t\t\t<plural>\n\t\t\t\t" + term.get_child(1).get_child(1).text + "\n\t\t\t</plural>\n\t\t\t<indefinate>\t\n\n\n\n" + term.get_child(2).get_child(1).get_item_text(term.get_child(2).get_child(1).selected) + "\n\t\t\t</indefinate>\n\t\t</term>\n"
			listOfTerms = listOfTerms + "\t</" + termset.name + ">\n"
	listOfTerms = listOfTerms + "</grammarsettings>\n"
	file.store_string(listOfTerms)
