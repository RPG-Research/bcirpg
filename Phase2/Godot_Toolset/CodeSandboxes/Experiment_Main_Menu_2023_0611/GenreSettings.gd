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
	$HBoxContainer/Default/GenreContainer.add_child(genreInstance)
	$HBoxContainer/Default/GenreContainer.move_child($HBoxContainer/Default/GenreContainer/NewGenre, $HBoxContainer/Default/GenreContainer.get_child_count() - 1)
