#CONFLICT SESSION (base class):
#	Shared plumbing for one running conflict. SimpleConflict and ExtendedConflict
#	extend this class and add their own steps and rules.
#	What this base class tries to handle:
#		- checking up front that the PC has what the conflict needs
#		- collecting every message for one screen and showing them together. The
#		  game view shows only one response at a time, so in the earlier version
#		  each action's result was replaced right away by the next prompt, and
#		  the player saw nothing happen until the turn ended.
#		- turning option presses ("CONFLICT:<kind>:<value>") into choices
#		- showing errors on screen (and in the debugger) with a way back out
#	The "view" is the Game node. A session only uses these four of its methods:
#		create_response(text), create_option(label, destination),
#		clear_prior_options(), focus_first_option()

extends Reference

signal finished(return_node)

#Every conflict option's destination starts with this, so Game can tell them
#	apart from module locale names.
const TOKEN_PREFIX = "CONFLICT:"
const END_STEP = "end"

var rules        #ConflictManagerD20
var pc_stats     #PcConflictStats
var view         #Game node
var npc = {}     #Dictionary from rules.make_default_npc()
var return_node = ""
var step = ""
var _lines = []  #messages waiting to be shown on the next screen

#FUNCTION: Init
#Params: rules (ConflictManagerD20), pc_stats (PcConflictStats), view (Game node)
func _init(rules_ref, pc_stats_ref, view_ref):
	rules = rules_ref
	pc_stats = pc_stats_ref
	view = view_ref

#FUNCTION: Start
#Params: module action params (params[0], if given, is the NPC name), and the
#	locale to return to when the conflict ends
#Returns: nothing; shows the first screen of the conflict, or an error screen
func start(params: Array, return_to: String) -> void:
	return_node = return_to
	var problem = pc_stats.find_start_problem(_required_caps())
	if problem != "":
		show_error(problem)
		_show()
		return
	var npc_name = "Bandit"
	if params.size() > 0 and str(params[0]).strip_edges() != "":
		npc_name = str(params[0]).strip_edges()
	npc = rules.make_default_npc(npc_name)
	_on_start()
	_show()

#FUNCTION: Handle token
#Params: option destination string, "CONFLICT:<kind>:<value>"
#Returns: nothing; applies the choice and shows the next screen
func handle_token(token: String) -> void:
	var parts = token.trim_prefix(TOKEN_PREFIX).split(":", false)
	if parts.size() != 2:
		show_error("Malformed conflict option '%s'; expected %s<kind>:<value>." % [token, TOKEN_PREFIX])
		_show()
		return
	if parts[0] == "end":
		emit_signal("finished", return_node)
		return
	_on_choice(parts[0], parts[1])
	_show()

#FUNCTION: Say
#Params: text to show on the next screen
#Returns: nothing
func say(text: String) -> void:
	_lines.append(text)

#FUNCTION: Show error
#Params: message describing what went wrong
#Returns: nothing; reports the error and switches to the end step, so the next
#	screen offers only a way back to the module
#Notes: the message goes to the debugger/console (push_error) and on screen, so
#	a tester can see and report it. It does not draw the screen itself; start()
#	and handle_token() each draw exactly once, after any error has been recorded.
func show_error(message: String) -> void:
	push_error("Conflict: " + message)
	_lines = ["[Conflict error] " + message]
	step = END_STEP

#FUNCTION: Add option
#Params: button label, choice kind, choice value
#Returns: nothing; adds a button that sends "CONFLICT:<kind>:<value>"
func add_option(label: String, kind: String, value: String) -> void:
	view.create_option(label, TOKEN_PREFIX + kind + ":" + value)

#FUNCTION: Show (internal)
#Params: none
#Returns: nothing; draws the waiting messages and the options for the current step
func _show() -> void:
	view.clear_prior_options()
	view.create_response(PoolStringArray(_lines).join("\n"))
	_lines.clear()
	if step == END_STEP:
		add_option("Continue", "end", "ok")
	else:
		_build_options()
	view.focus_first_option()

#The four methods below are for the subclasses to override. The base versions
#	only report that a subclass forgot one.

#FUNCTION: Required capabilities
#Returns: Array of capability names the PC must have ("Health" is always added)
func _required_caps() -> Array:
	push_error("ConflictSession: subclass did not override _required_caps()")
	return []

#FUNCTION: On start
#Notes: set the first step and say the opening text
func _on_start() -> void:
	push_error("ConflictSession: subclass did not override _on_start()")

#FUNCTION: On choice
#Params: kind and value from the pressed option
func _on_choice(_kind: String, _value: String) -> void:
	push_error("ConflictSession: subclass did not override _on_choice()")

#FUNCTION: Build options
#Notes: add the buttons for the current step (not called for the end step)
func _build_options() -> void:
	push_error("ConflictSession: subclass did not override _build_options()")
