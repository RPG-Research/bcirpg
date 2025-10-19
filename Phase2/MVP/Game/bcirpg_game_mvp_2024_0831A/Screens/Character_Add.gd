#CHARACTER_ADD:
#	Script for adding a new character and both saving it to file and loading 
#		it into the character object


extends Control

onready var settings = get_node("/root/GlobalSaveInstance").settingsInstance
onready var pSingleton = get_node("/root/PlayerCharacter").pc

const Perc_Cap = preload("res://UserInterface/Capacity.tscn")
var cust_cap_count = 0

#GSP is to hold instantiated GSP_Layer; needed for calling necessary conversion functionality
const Game_Layer := preload("res://globalScripts/GSP_Lookups.gd")
onready var GSP = Game_Layer.new()

const Cap_New_Button = preload("res://UserInterface/Option.tscn")

func _ready() -> void:
	theme=load(settings.themeFile)
	$Title/But_SaveChar.grab_focus()
	_populate_output_character_format()

#This function is helper function for name dropdown task and should be added in ImportCharacter.gd file to 
# add dropdwon functionality there
# FUNCTION: get_character_names_from_csv_folder
# --------------------------------------------
# Scans the res://_userFiles/characterFiles/ directory for all character CSV files
# matching the pattern *_data.csv. Extracts and returns the character names (from filenames)
# to populate the character name dropdown (OptionButton) in the UI.
#
# RETURNS:
#   Array of character names as strings, e.g. ["Bilbo Baggins", "Gandalf"]
#func get_character_names_from_csv_folder() -> Array:
#	var names = []
#	var dir := Directory.new()

#	if dir.open("res://_userFiles/characterFiles/") != OK:
#		print("❌ Failed to open characterFiles directory.")
#		return names

#	dir.list_dir_begin()
#	while true:
#		var file_name = dir.get_next()
#		if file_name == "":
#			break
#		if !dir.current_is_dir() and file_name.ends_with("_data.csv"):
#			var name_only = file_name.replace("_data.csv", "")
#			names.append(name_only)
#	dir.list_dir_end()
#
#	return names
	
#FUNCTION populate preset character format
#Params: file we have opened and are reading
#Returns: Nothing; all work done in function
#Notes: This adjusts  output using what we know, that is: set character sheet format, and a csv that 
#	has all headers in the top line, and all values in the next line
#	NOTE: this assumes we have matching lines, and our csv matches
#TODO: Next step  here is run the GSP converted to also update the percentile/singleton
func _populate_output_character_format():
	var i = 0
	# Original code - COMMENTED OUT:
	#make a new textbox for each header piece
	var set_labels = ["NAME","PROFESSION","QUOTE"]
	for set in set_labels:
		var setLine = Label.new()
		setLine.text = set
		$Title/ScrollContainer/VBoxContainer.add_child(setLine)
		cust_cap_count= cust_cap_count+1
		var setBox = LineEdit.new()
		$Title/ScrollContainer/VBoxContainer.add_child(setBox)
		cust_cap_count = cust_cap_count+1

# Updated code to replace NAME textbox with a dropdown (OptionButton)
###############
#	var set_labels = ["NAME", "PROFESSION", "QUOTE"]
#	for set in set_labels:
#	# Create label for each field
#		var setLine = Label.new()
#		setLine.text = set
#		$Title/ScrollContainer/VBoxContainer.add_child(setLine)
#		cust_cap_count += 1

#		if set == "NAME":
#			# Replace LineEdit with OptionButton (dropdown) for NAME
#			var name_dropdown = OptionButton.new()
#			name_dropdown.name = "NameOption"  # Assign a name so we can access it later
#			# Add options from predefined character presets
#			for char_name in get_character_names_from_csv_folder():
#				name_dropdown.add_item(char_name)
#			# Connect dropdown selection signal
#			name_dropdown.connect("item_selected", self, "_on_name_selected")
#			# Add dropdown to the form
#			$Title/ScrollContainer/VBoxContainer.add_child(name_dropdown)
#			cust_cap_count += 1
#		else:
#			# Keeps LineEdit for PROFESSION and QUOTE
#			var setBox = LineEdit.new()
#			$Title/ScrollContainer/VBoxContainer.add_child(setBox)
#			cust_cap_count += 1
###############

	#DKM TEMP (12/22/24): Putting in direct access to the percentile system, as 
	#	the Capabilities system is tested. These values should be set on the GSP as
	#	per all systems. 
	if (settings.game_selection == "BCIRPG_PERCENTILE"):
		pSingleton.is_output_B = false
		pSingleton.output_A_label = ""
		#Add a button to add new capacities at the bottom:
		var add_cap_but = Cap_New_Button.instance()
		add_cap_but.text = "Add New Capacity"
		add_cap_but.destinationLabel = "NA"
		$Title/ScrollContainer/VBoxContainer.add_child(add_cap_but)
		$Title/ScrollContainer/VBoxContainer.get_child(cust_cap_count).connect("option_pressed", self, "_on_new_cap_pressed")
		cust_cap_count = cust_cap_count+1
		for label in pSingleton.source_backend_capabilities:
			var textLine = Label.new()
			$Title/ScrollContainer/VBoxContainer.add_child(textLine)
			cust_cap_count = cust_cap_count+1
			textLine.text = label
			var textBox = LineEdit.new()
			$Title/ScrollContainer/VBoxContainer.add_child(textBox)
			cust_cap_count = cust_cap_count+1	

	else:
		for label in pSingleton.output_labels:
			var textLine = Label.new()
			$Title/ScrollContainer/VBoxContainer.add_child(textLine)
			textLine.text = label.to_upper()
			i = i+1
			#match to content, assuming it exists and aligns
			if(pSingleton.output_scores_A.size()>= i):
				var textBox = LineEdit.new()
				$Title/ScrollContainer/VBoxContainer.add_child(textBox)
				var ability_text = str(pSingleton.output_scores_A[i-1])
				if(pSingleton.output_A_label.length() > 0):
					ability_text = ability_text + pSingleton.output_A_label
					if(pSingleton.is_output_B && pSingleton.output_scores_B.size()>= i):
						if(pSingleton.output_B_label.length() > 0):
							ability_text = ability_text + pSingleton.output_B_label
						ability_text = ability_text + str(pSingleton.output_scores_B[i-1])
				textBox.text = ability_text

#FUNCTION helper rem cap pressed
#Params: the parent node of the remove button being pressed
#Returns: Nothing; all work done in function
#Notes: Connecting to a capacity's internal button signal, this function's goal is
#	to remove the capacity on the button pressed from the character sheet. 
func _on_rem_cap_pressed(cap_par: Node) -> void:
	print("Connection made! Passed name is: " + cap_par.name)
	#var target_cap = $Title/ScrollContainer/VBoxContainer.find_child(child_idx)
	$Title/ScrollContainer/VBoxContainer.remove_child(cap_par)
	#target_cap.queue_free()
	cust_cap_count = cust_cap_count-1

#FUNCTION helper add cap pressed
#Params: NA, this is currently un-used. Retained to salvage the options button
#Returns: Nothing; all work done in function
#Notes: Adds a new capacity at the bottom of the character sheet, saving the parent node
#	so it can be removed regardless of order
func _on_new_cap_pressed(NA: String) -> void:
	print("Connected to the new cap, too!")
	var new_cap = Perc_Cap.instance()
	$Title/ScrollContainer/VBoxContainer.add_child(new_cap)
	cust_cap_count = cust_cap_count+1
	print("Current count set to: " + str(cust_cap_count))
	#Get the remove button on the capacity node to connect signal:
	var cap_node_but = $Title/ScrollContainer/VBoxContainer.get_child(cust_cap_count-1).get_child(0).get_child(0).get_child(1)
	#This sets the child count currently for future reference (to enable dynamic removes)
	cap_node_but.cap_setting = $Title/ScrollContainer/VBoxContainer.get_child(cust_cap_count-1)
	cap_node_but.connect("rem_cap_pressed", self, "_on_rem_cap_pressed") 


#FUNCTION save data to character singleton
#Params: None
#Returns: Nothing; all work done in function
#Notes: Reads the input fields, breaking headers out, then parsing lines to look 
#	for the relevant fields for the system. It saves to the singleton output fields. 
#TODO: This should poll the game system in use first, for validing what output fields
#	to save; it should also call the GSP conversion once done to update the percentile values, too.
func save_data_to_singleton() -> void:
	#Values divisions provided for game system variations
	#TODO: ascertain if these are sufficiently robust?
	var is_label = true
	var skip_next = false
	var box_count = 0
	#DKM TEMP (2/2/25): As testing direct-access for bcirpg percentile, this game type bypasses
	#	the output character attributes and writes directly to the backend stats. 
	if (settings.game_selection == "BCIRPG_PERCENTILE"):
		pSingleton.populate_default_character()
		for child_box in $Title/ScrollContainer/VBoxContainer.get_children():
			is_label = child_box.get_class() == "Label"
			if is_label:
				var label_value = child_box.text.strip_edges(true,true).to_upper()
				match label_value:
					"NAME":
						if $Title/ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.name = str($Title/ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						box_count = box_count+2
					"PROFESSION":
						if $Title/ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.profession = str($Title/ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						box_count = box_count+2
					"QUOTE":
						if $Title/ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.quote = str($Title/ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						box_count = box_count+2
				#DKM TEMP (2/9/25): May want to rethink building the custom on player and updating here. WIP.
				#	This is otherwise EXTREMELY manual
					"AG":
						print("Check: AG found!")
						if $Title/ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.player_capabilities[0].score = str($Title/ScrollContainer/VBoxContainer.get_child(box_count+2).text)
							print("AG set to:" + pSingleton.player_capabilities[0].score)
						box_count = box_count+3
					"APP":
						if $Title/ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.player_capabilities[1].score = str($Title/ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						box_count = box_count+2
					"CO":
						if $Title/ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.player_capabilities[2].score = str($Title/ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						box_count = box_count+2
					"QU":
						if $Title/ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.player_capabilities[3].score = str($Title/ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						box_count = box_count+2
					"MD":
						if $Title/ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.player_capabilities[4].score = str($Title/ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						box_count = box_count+2
					"ST":
						if $Title/ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.player_capabilities[5].score = str($Title/ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						box_count = box_count+2
					"CH":
						if $Title/ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.player_capabilities[6].score = str($Title/ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						box_count = box_count+2
					"EM":
						if $Title/ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.player_capabilities[7].score = str($Title/ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						box_count = box_count+2
					"IN":
						if $Title/ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.player_capabilities[8].score = str($Title/ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						box_count = box_count+2
					"ME":
						if $Title/ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.player_capabilities[9].score = str($Title/ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						box_count = box_count+2
					"MX":
						if $Title/ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.player_capabilities[10].score = str($Title/ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						box_count = box_count+2
					"PR":
						if $Title/ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.player_capabilities[11].score = str($Title/ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						box_count = box_count+2
					"RE":
						if $Title/ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.player_capabilities[12].score = str($Title/ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						box_count = box_count+2
					"SD":
						if $Title/ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.player_capabilities[13].score = str($Title/ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						box_count = box_count+2
			#Capacity object:
			elif child_box.get_class() == "PanelContainer":
				var new_cap = pSingleton.Capability_Source.new()
				var cap_source = child_box.get_children()[0].get_children()
				for cap_item in cap_source[0].get_children():
					if cap_item.get_name() == "LocaleName" || cap_item.get_name() == "But_RemC":
						pass
					elif cap_item.get_class() != "Label":
						match cap_item.get_name():
							"CapName":
								new_cap.name = str(cap_item.text)
							"Score":
								new_cap.score = int(cap_item.text)
							"AttackBox":
								new_cap.attack = cap_item.is_pressed()
							"DefendBox":
								new_cap.defend = cap_item.is_pressed()
							"Use_Range":
								new_cap.use_range = int(cap_item.text)
							"Duration":
								new_cap.duration = int(cap_item.text)
							"Impact_Target":
								new_cap.impact_target = str(cap_item.text)
							"Impact_Amount":
								new_cap.impact_amount = int(cap_item.text)
							"Uses_Max":
								new_cap.uses_max = int(cap_item.text)
							"Uses_Current":
								new_cap.uses_current = int(cap_item.text)
							"Recharge":
								new_cap.recharge = cap_item.is_pressed()
							"Reload":
								new_cap.reload = cap_item.is_pressed()
							"Modifier":
								new_cap.modifier = int(cap_item.text)
				print ("Cap values saved as: " + new_cap.to_string())
				pSingleton.player_capabilities.append(new_cap)
		pSingleton.set_health()
		pSingleton.set_defense()
		#Now set output values, too:
		pSingleton.is_output_B = false
		pSingleton.output_A_label = ""
		var char_labels = []
		var char_values_A = []
		for pc_cap in pSingleton.player_capabilities:
			char_labels.append(pc_cap.name)
			char_values_A.append(pc_cap.score)
		pSingleton.output_labels = char_labels
		pSingleton.output_scores_A = char_values_A
	else:
		var char_labels = []
		var char_values_A = []
		var char_values_B = []
		
		for child_box in $Title/ScrollContainer/VBoxContainer.get_children():
			is_label = child_box.get_class() == "Label"
			if is_label:
				var label_value = child_box.text.strip_edges(true,true).to_upper()
				match label_value:
					"NAME":
						if $Title/ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.name = str($Title/ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						print("TEMP name found! As : " + str(pSingleton.name))
						skip_next = true
					"PROFESSION":
						if $Title/ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.profession = str($Title/ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						print("TEMP prof found! As : " + str(pSingleton.profession))
						skip_next = true
					"QUOTE":
						if $Title/ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.quote = str($Title/ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						print("TEMP quote found! As : " + str(pSingleton.quote))
						skip_next = true
					_:
						skip_next = false
						char_labels.append(child_box.text.strip_edges(true,true).to_upper())
			elif !skip_next:
				print ("TEMP: raw value returned is:" + child_box.text)
				#Output B in use means we have a multi-part attributes system
				if pSingleton.is_output_B:
					var A_label_idx = child_box.text.find(pSingleton.output_A_label)
					if(A_label_idx >=0):
						char_values_A.append(int(child_box.text.substr(0,A_label_idx)))
						char_values_B.append(int(child_box.text.substr(A_label_idx+1,child_box.text.length()-1)))
				else: 
					char_values_A.append(int(child_box.text))
			box_count = box_count +1
			
	#Output capabilities are created here, for general input. 
		var i = 0;
		for named in char_labels:
			var current = pSingleton.Capability_Source.new()
			current.Game_Name = named
			current.Game_toDisplay = true
			current.Game_Value = char_values_A[i]
			current.Game_Extras = char_values_B[i]
			current.Game_Raw = str(char_values_A[i]) + "D+" + str(char_values_B[i])
			pSingleton.player_capabilities.append(current)
			i = i+1;
	#	Ref: char_sheet_converter (game:String, source_char:playerCharacterTemplate, char_in:bool)->playerCharacterTemplate
		pSingleton = GSP.char_sheet_converter(settings.game_selection, pSingleton, true)
#Prior system:
#		pSingleton.output_labels = char_labels
#		pSingleton.output_scores_A  = char_values_A
#		pSingleton.output_scores_B  = char_values_B

#FUNCTION save character csv
#Params: none
#Returns: Nothing; all work done in function
#Notes: This saves the character output fields to a csv.
#	TO DO: this is not safe at all; we can't just take a player entered name
#		for a file name, we need to validate it. 
func save_data_to_csv() -> void:
	var file_path = ""
	if str(pSingleton.name) != "":
		file_path = "user://" + str(pSingleton.name) + "_data.csv"
	else: 
		 file_path = "user://character_data.csv"
	var file = File.new()
	if file.open(file_path, File.WRITE) == OK:
		var csv_labels = ""
		for extra in pSingleton.output_extras:
			csv_labels = csv_labels + extra + ","
		for name in pSingleton.output_labels:
			csv_labels = csv_labels + name + ","
		csv_labels = csv_labels + "\n"
		csv_labels = csv_labels + str(pSingleton.name) + "," + str(pSingleton.profession)+ "," + str(pSingleton.quote)+ ","
		var labels_counter = 0
		for val in pSingleton.output_scores_A:
			csv_labels = csv_labels + str(val)
			if pSingleton.output_A_label.length() > 0:
				 csv_labels = csv_labels + str(pSingleton.output_A_label)
			if pSingleton.is_output_B:
				if pSingleton.output_B_label.length() > 0:
					csv_labels = csv_labels + " " + str(pSingleton.output_B_label) + " "
					csv_labels = csv_labels + str(pSingleton.output_scores_B[labels_counter])
			labels_counter = labels_counter +1
			csv_labels = csv_labels + ","
		#TO DO:add the values, too.
		file.store_string(csv_labels)
		file.close()
		print("Data saved to ", file_path)
		print(OS.get_data_dir())
	else:
		print("Failed to open", file_path, "for writing.")


func _on_But_SaveChar_pressed(): 
	save_data_to_singleton()
	save_data_to_csv()
	
#takes appropriate action when the custom hotkey is pressed
func _unhandled_input(event):
	if Input.is_action_pressed("save_character_file_hotkey"):
		save_data_to_singleton()
		save_data_to_csv()

