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
var modifier = 0
	
func to_string() -> String:
	var output_text = "name:" + str(name)
	output_text = output_text + ",score:" + str(score) + ",attack:" + str(attack)
	output_text = output_text + ",defend:" + str(defend) + ",use_range:" + str(use_range)
	output_text = output_text + ",duration:" + str(duration) + ",impact_target:" + str(impact_target)
	output_text = output_text + ",impact_amount:" + str(impact_amount) + ",uses_max:" + str(uses_max)
	output_text = output_text + ",uses_current:" + str(uses_current) + ",recharge:" + str(recharge)
	output_text = output_text + ",reload:" + str(reload) + ",modifier:" + str(modifier)
	return output_text
