extends Label

var newTerm = load("res://term_container.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_button_up():
	var termInstance = newTerm.instantiate()
	$VBoxContainer/OptionButton/ScrollContainer/VBoxContainer.add_child(termInstance)
	$VBoxContainer/OptionButton/ScrollContainer/VBoxContainer.move_child($VBoxContainer/OptionButton/ScrollContainer/VBoxContainer/Button, $VBoxContainer/OptionButton/ScrollContainer/VBoxContainer.get_child_count() - 1)
	
