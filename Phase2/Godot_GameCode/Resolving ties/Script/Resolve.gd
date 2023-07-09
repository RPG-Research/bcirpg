extends Control

onready var player_1_stats = 0
onready var player_2_stats = 0
onready var line_edit_1 = $Player1/LineEdit
onready var line_edit_2 = $Player2/LineEdit
onready var result = $Result

func _ready():
	line_edit_1.grab_focus()
	

func _physics_process(delta):
	if player_1_stats != 0 and player_2_stats != 0 and !result.is_visible_in_tree():
		if player_1_stats > player_2_stats:
			$Result/RichTextLabel.add_text("Player 1 wins!")
			$Result.visible = true
			
		elif player_2_stats > player_1_stats:
			$Result/RichTextLabel.add_text("Player 2 wins!")
			$Result.visible = true
		else:
			$Result/RichTextLabel.add_text("Re-roll!")
			$Result.visible = true

func _on_TextureButton1_pressed():
	player_1_stats = int(line_edit_1.text)


func _on_TextureButton2_pressed():
	player_2_stats = int(line_edit_2.text)


func _on_ResetButton_pressed():
	player_1_stats = 0
	player_2_stats = 0
	line_edit_1.clear()
	line_edit_2.clear()
	$Result/RichTextLabel.clear()
	result.visible = false
