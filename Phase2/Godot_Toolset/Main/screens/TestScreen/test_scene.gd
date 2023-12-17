extends Node


func _ready():
	print(SpecialAbility.create_ability("Fireball",
	["Fire Type", "Projectile"],
	1,
	10,
	5,
	3.0,
	"strength",
	Vector3(1, 2, 3)
))
