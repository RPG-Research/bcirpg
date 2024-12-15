#CHARACTER CAPABILITY: 
#	Object to handle each character capability. These will be used for backend percentile, to cover any possible attribute, skill, power, spell, key equipment, etc

class_name Char_Capability

var name
var score = 0
var attack = false
var defend = false
var use_range = 0
var duration = -1
var impact_target
var impact_amount = 0
var uses_max = 0
var uses_current = 0
var recharge = false
var reload = false
var modifiers = 0
	
	
