extends Node



# Called when the node enters the scene tree for the first time.
func _ready():
	$GenreMenu.hide()
	$DialogMenu.hide()
	$CharacterMenu.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_option_button_wizards_item_selected(index):
	var newGenre = load("res://new_genre.tscn")
	var toLoad
	var data
	var parser = XMLParser.new()
	match index:
		0:
			$GenreMenu.show()
			$DialogMenu.hide()
			$CharacterMenu.hide()
			parser.open("user://GenreSettings.xml")
			var loaded_name = ""
			var name_loaded = false
			var loaded_def = false
			var def_loaded = false
			var loadedBase
			var base_loaded = false
			while parser.read() != ERR_FILE_EOF:
				if parser.get_node_type() == XMLParser.NODE_ELEMENT:
					var node_name = parser.get_node_name()
					if node_name == "default":
						var node_data = parser.get_node_data()
						if node_data == "true":
							loaded_def = true
						else:
							loaded_def = false
						def_loaded = true
						
					elif node_name == "name":
						loaded_name = parser.get_node_data()
						if loaded_name != "Fantasy" and loaded_name != "Science Fiction" and loaded_name != "Modern Day":
							name_loaded = true
					elif node_name == "basedOn":
						base_loaded = true
						loadedBase = parser.get_node_data()
				if def_loaded and name_loaded and base_loaded:
					pass
					var genreInstance = newGenre.instantiate()
					genreInstance.GetChild(0).GetChild(0).Pressed = loaded_def
					genreInstance.GetChild(0).GetChild(1).text = loaded_name
					if loadedBase == "Modern Day":
						genreInstance.getChild(0).GetChild(3).Selected = 0
					elif loadedBase == "Sci Fi":
						genreInstance.getChild(0).GetChild(3).Selected = 1
					elif loadedBase == "Fantasy":
						genreInstance.getChild(0).GetChild(3).Selected = 2
					$GenreMenu/HBoxContainer/Default/ScrollContainer/GenreContainer.add_child(genreInstance)
					$GenreMenu/HBoxContainer/Default/ScrollContainer/GenreContainer.move_child($GenreMenu/HBoxContainer/Default/ScrollContainer/GenreContainer/NewGenre, $GenreMenu/HBoxContainer/Default/ScrollContainer/GenreContainer.get_child_count() - 1)
					def_loaded = false
					name_loaded = false
		1:
			$GenreMenu.hide()
			$DialogMenu.show()
			$CharacterMenu.hide()
			var newTerm = load("res://term_container.tscn")
			parser.open("user://DialougeSettings.xml")
			var unselected = true
			while parser.read() != ERR_FILE_EOF:
				if parser.get_node_type() == XMLParser.NODE_ELEMENT:
					if $DialogMenu/VBoxContainer.get_child($VBoxContainer.get_child_count() - 1).get_child(0).get_child(0).get_child(1).text == "":
						var termInstance = newTerm.instantiate()
						unselected = true
						termInstance.get_child(0).get_child(0).get_child(1).text = parser.get_node_data()
						$DialogMenu/VBoxContainer.add_child(termInstance)
						$DialogMenu/VBoxContainer.move_child($VBoxContainer/Button, $VBoxContainer.get_child_count() - 1)
					elif $DialogMenu/VBoxContainer.get_child($VBoxContainer.get_child_count() - 1).get_child(0).get_child(1).get_child(1).text == "":
						$DialogMenu/VBoxContainer.get_child($VBoxContainer.get_child_count() - 1).get_child(0).get_child(1).get_child(1).text = parser.get_node_data()
					elif unselected:
						$DialogMenu/VBoxContainer.get_child($VBoxContainer.get_child_count() - 1).get_child(1).get_child(1).Selected = parser.get_node_data()
		2:
			$GenreMenu.hide()
			$DialogMenu.hide()
			$CharacterMenu.show()
