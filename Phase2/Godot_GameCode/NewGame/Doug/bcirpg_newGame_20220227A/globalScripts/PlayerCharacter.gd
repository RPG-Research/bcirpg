#PLAYER CHARACTER: 
#	Unique handler script for root PC singleton.  May be adapted for 
#		player loading and saving functionality

extends Node

var playerCharacterSingleton 

func _ready() -> void:
	playerCharacterSingleton = playerCharacterTemplate.new()
	
