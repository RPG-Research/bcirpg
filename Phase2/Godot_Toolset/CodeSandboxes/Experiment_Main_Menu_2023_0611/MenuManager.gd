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
	match index:
		0:
			$GenreMenu.show()
			$DialogMenu.hide()
			$CharacterMenu.hide()
		1:
			$GenreMenu.hide()
			$DialogMenu.show()
			$CharacterMenu.hide()
		2:
			$GenreMenu.hide()
			$DialogMenu.hide()
			$CharacterMenu.show()
