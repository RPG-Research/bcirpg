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


func _on_v_scroll_bar_scrolling():
	$HboxContainer
