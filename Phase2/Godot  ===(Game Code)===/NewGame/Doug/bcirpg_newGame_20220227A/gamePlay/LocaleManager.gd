#LOCALE MANAGER:
#	Temporary script holds connections between map items, using the two-way
#		connect_exit script available on Location class to wire up map.

extends Node


#DKM TEMP: must load from toolset
func _ready() -> void:
	#load_module()
	$Loc_Boat.connect_exit("east", $Loc_Shore)
	$Loc_Shore.connect_exit("north", $Loc_WoodsA1)
	$Loc_WoodsA1.connect_exit("north", $Loc_WoodsA2)
	$Loc_WoodsA2.connect_exit("east", $Loc_WoodsA3)
	$Loc_WoodsA3.connect_exit("north", $Loc_WoodsA4)



