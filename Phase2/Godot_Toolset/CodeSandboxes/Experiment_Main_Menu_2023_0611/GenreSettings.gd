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
	var file = FileAccess.open("user://test.xml", FileAccess.WRITE)
	if file:
		file.store_string("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<genresettings>\n")
		#for each genre container
		#add name and what it's based on. skip based on if first three.
		file.store_string("</genresettings>")
		file.close()
