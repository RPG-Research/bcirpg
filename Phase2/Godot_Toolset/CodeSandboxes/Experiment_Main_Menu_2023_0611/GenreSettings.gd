extends Node

var newGenre = load("res://new_genre.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_new_genre_button_up():
	var genreInstance = newGenre.instantiate()
	$HBoxContainer/Default/ScrollContainer/GenreContainer.add_child(genreInstance)
	$HBoxContainer/Default/ScrollContainer/GenreContainer.move_child($HBoxContainer/Default/ScrollContainer/GenreContainer/NewGenre, $HBoxContainer/Default/ScrollContainer/GenreContainer.get_child_count() - 1)




func _on_save_button_pressed():
	var listOfGenres = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<genresettings>\n"
	var file = FileAccess.open("user://GenreSettings.xml", FileAccess.WRITE)
	var fromFile = $HBoxContainer/Default/ScrollContainer/GenreContainer.get_children()
	#go through each genre in the list and add them to the string to be added to the file
	for genre in fromFile:
		if genre is HBoxContainer:
			listOfGenres= listOfGenres + "\t<genre>\n"
			if genre.get_child_count() > 2:
				listOfGenres = listOfGenres + "\t\t<default>\n\t\t\t" + str(genre.get_child(0).is_pressed()) + "\n\t\t</default>\n" + "\t\t<name>\n\t\t\t" + genre.get_child(1).text + "\n\t\t</name>\n" + "\t\t<basedOn>\n\t\t\t" + genre.get_child(2).Selected + "\n\t\t</basedOn>\n\t</genre>\n"
			else:
				listOfGenres= listOfGenres + "\t\t<default>\n\t\t\t" + str(genre.get_child(0).is_pressed()) + "\n\t\t</default>\n" + "\t\t<name>\n\t\t\t" + genre.get_child(1).text + "\n\t\t</name>\n\t</genre>\n"
	listOfGenres = listOfGenres + "</genresettings>\n"
	file.store_string(listOfGenres)
