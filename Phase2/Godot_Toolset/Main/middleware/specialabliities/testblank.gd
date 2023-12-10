

extends Node

func _ready():
	var SpecialAbility = preload("res://middleware/specialabliities/SpecialAbility.gd")
	var special_ability = SpecialAbility.new("Fireball", ["Fire Type", "Projectile"], 1, 10, 0, 5.0, "strength", Vector3(1, 1, 1))
	print(special_ability.to_string())
