#PLAYER CHARACTER: 
#	Unique handler script for root PC singleton.  May be adapted for 
#		player loading and saving functionality.

# 	Values are pulled from PlayerCharacterTemplate.gd

extends Node

var pc

func _ready() -> void:
	pc = playerCharacterTemplate.new()

