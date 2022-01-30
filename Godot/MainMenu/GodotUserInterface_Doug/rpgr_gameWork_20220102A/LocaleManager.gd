#LOCALE MANAGER:
#	Temporary script holds connections between map items, using the two-way
#		connect_exit script available on Location class to wire up map.

extends Node


func _ready() -> void:
	$HouseLocale.connect_exit("east", $HouseOutside)



