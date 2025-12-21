extends Control

#GRAB FOCUS: simple script for temp files to grab focus


func _ready() -> void:
	$Title/But_ChangeScene.call_deferred("grab_focus")
