extends PanelContainer


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var outputFolderStr = "Region\n\tLocation\n\t\tSpace\n\t\t\tScene" + "\n\t\tSpace"
	$VLayout/HBoxContainer/TabContainer/Structural_Tab/TextEdit.text = outputFolderStr

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

