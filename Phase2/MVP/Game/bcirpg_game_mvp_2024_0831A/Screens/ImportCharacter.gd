#GRAB FOCUS: simple script for temp files to grab focus
#	Expanded for Import Character option

#DKM TEMP: TO DO: As with the character add, we need this to read what's 
#	handed to it and generate the output from that, rather than have this be hard-coded. 

extends Control

onready var settings = get_node("/root/GlobalSaveInstance").settingsInstance
onready var pSingleton = get_node("/root/PlayerCharacter").pc

const Perc_Cap = preload("res://UserInterface/Capacity.tscn")
#Import functionality has 2 extra fields
var cust_cap_count = 2

#GSP is to hold instantiated GSP_Layer; needed for calling necessary conversion functionality
const Game_Layer := preload("res://globalScripts/GSP_Lookups.gd")
onready var GSP = Game_Layer.new()

const Cap_New_Button = preload("res://UserInterface/Option.tscn")

var charFilePath
var a

func _ready() -> void:
	theme=load(settings.themeFile)
	_populate_output_character_format()
	#Uncomment this if we want to grab focus on the "Open Character File" option by default
	#$VBoxContainer2/But_OpenFile.grab_focus()
	$But_Play.grab_focus() #This will grab focus on the "Start Game" option by default

func _on_Button_pressed():
	$FileDialog.popup()

#takes appropriate action when the custom hotkey is pressed
func _unhandled_input(event):
	if Input.is_action_pressed("open_file_hotkey"):
		$FileDialog.popup()

	if Input.is_action_pressed("save_character_file_hotkey"):
		_save_data_to_singleton()

#FUNCTION populate preset character format
#Params: file we have opened and are reading
#Returns: Nothing; all work done in function
#Notes: This adjusts  output using what we know, that is: set character sheet format, and a csv that 
#	has all headers in the top line, and all values in the next line
#	NOTE: this assumes we have matching lines, and our csv matches
#TODO: Next step  here is run the GSP converted to also update the percentile/singleton
func _populate_output_character_format():
	var i = 0
	#make a new textbox for each header piece
	var set_labels = ["NAME","PROFESSION","QUOTE"]
	for set in set_labels:
		var setLine = Label.new()
		setLine.text = set 
		$ScrollContainer/VBoxContainer.add_child(setLine)
		cust_cap_count= cust_cap_count+1
		var setBox = LineEdit.new()
		$ScrollContainer/VBoxContainer.add_child(setBox)
		cust_cap_count = cust_cap_count+1


	#DKM TEMP (12/22/24): Putting in direct access to the percentile system, as 
	#	the Capabilities system is tested. These values should be set on the GSP as
	#	per all systems. 
	_add_capability_button()
	if (settings.game_selection == "BCIRPG_PERCENTILE"):
		pSingleton.is_output_B = false
		pSingleton.output_A_label = ""

		for label in pSingleton.source_backend_capabilities:
			var textLine = Label.new()
			$ScrollContainer/VBoxContainer.add_child(textLine)
			cust_cap_count = cust_cap_count+1
			textLine.text = label
			var textBox = LineEdit.new()
			$ScrollContainer/VBoxContainer.add_child(textBox)
			cust_cap_count = cust_cap_count+1	

	else:
		for label in pSingleton.output_labels:
			var textLine = Label.new()
			$ScrollContainer/VBoxContainer.add_child(textLine)
			cust_cap_count = cust_cap_count+1
			textLine.text = label.to_upper()
			i = i+1
			#match to content, assuming it exists and aligns
			if(pSingleton.output_scores_A.size()>= i):
				var textBox = LineEdit.new()
				$ScrollContainer/VBoxContainer.add_child(textBox)
				cust_cap_count = cust_cap_count+1
				var ability_text = str(pSingleton.output_scores_A[i-1])
				if(pSingleton.output_A_label.length() > 0):
					ability_text = ability_text + pSingleton.output_A_label
					if(pSingleton.is_output_B && pSingleton.output_scores_B.size()>= i):
						if(pSingleton.output_B_label.length() > 0):
							ability_text = ability_text + pSingleton.output_B_label
						ability_text = ability_text + str(pSingleton.output_scores_B[i-1])
				textBox.text = ability_text

			
#FUNCTION populate preset character format
#Params: file we have opened and are reading
#Returns: Nothing; all work done in function
#Notes: This adjusts  output using what we know, that is: set character sheet format, and a csv that 
#	has all headers in the top line, and all values in the next line
#	NOTE: this assumes we have matching lines, and our csv matches
#TODO: Next step  here is run the GSP converted to also update the percentile/singleton
func _populate_preset_character_format(file:File):
	while file.eof_reached() == false:
		var csvStrHeaderArray = file.get_csv_line()
		var csvStrContentsArray = file.get_csv_line()
		cust_cap_count = 0
		for i in csvStrHeaderArray.size():
			#make a new textbox for each header piece
			var textLine = Label.new()
			$ScrollContainer/VBoxContainer.add_child(textLine)
			cust_cap_count = cust_cap_count + 1
			textLine.text = csvStrHeaderArray[i].to_upper()
			
			#match to content, assuming it exists and aligns
			if(csvStrContentsArray.size()>= i):
				var textBox = LineEdit.new()
				$ScrollContainer/VBoxContainer.add_child(textBox)
				cust_cap_count = cust_cap_count + 1
				textBox.text = csvStrContentsArray[i]
				
			if(textLine.text=="QUOTE"):
				_add_capability_button()
				
	
	# Set focus order for dynamically created LineEdit fields
	var previous_control = $VBoxContainer2/Save_Button
	for child in $ScrollContainer/VBoxContainer.get_children():
		if child is LineEdit:
			child.focus_previous = previous_control.get_path()
			previous_control.focus_next = child.get_path()
			previous_control = child
	
	# Connect the last LineEdit back to the first button
	if previous_control != $VBoxContainer2/Save_Button:
		previous_control.focus_next = $VBoxContainer2/But_OpenFile.get_path()
		$VBoxContainer2/But_OpenFile.focus_previous = previous_control.get_path()


#FUNCTION clear the character sheet
#Params: None
#Returns: Nothing; all work done in function
#Notes: Clears the display so additional characters may be 
#	loaded by releasing the queue and removing UI items. 
func _clear_char_sheet() -> void:
	for n in $ScrollContainer/VBoxContainer.get_children():
		$ScrollContainer/VBoxContainer.remove_child(n)
		n.queue_free()

#this is going to take information from the file the player chose and put the individul parts into textboxes so it can be edited and then saved
func _on_FileDialog_file_selected(path):
	_clear_char_sheet()
	var file = File.new()
	#read the text in the file, save it in the variable a
	file.open(path, File.READ)
	_populate_preset_character_format(file)
	
	file.close()
	$VBoxContainer2/But_OpenFile.grab_focus()
	
#FUNCTION save data to character singleton
#Params: None
#Returns: Nothing; all work done in function
#Notes: Reads the input fields, breaking headers out, then parsing lines to look 
#	for the relevant fields for the system. It saves to the singleton output fields. 
#TODO: This should poll the game system in use first, for validing what output fields
#	to save; it should also call the GSP conversion once done to update the percentile values, too.
func _save_data_to_singleton() -> void:
	#Values divisions provided for game system variations
	#TODO: ascertain if these are sufficiently robust?
	var is_label = true
	var skip_next = false
	var box_count = 0
	#For repeated saves, start fresh:
	pSingleton.clear_character()
	if (settings.game_selection == "BCIRPG_PERCENTILE"):
		pSingleton.populate_default_character()
		for child_box in $ScrollContainer/VBoxContainer.get_children():
			is_label = child_box.get_class() == "Label"
			if is_label:
				var label_value = child_box.text.strip_edges(true,true).to_upper()
				match label_value:
					"NAME":
						if $ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.name = str($ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						box_count = box_count+2
					"PROFESSION":
						if $ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.profession = str($ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						box_count = box_count+2
					"QUOTE":
						if $ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.quote = str($ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						box_count = box_count+2
				#DKM TEMP (2/9/25): May want to rethink building the custom on player and updating here. WIP.
				#	This is otherwise EXTREMELY manual
					"AG":
						print("Check: AG found!")
						if $ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.player_capabilities[0].score = str($ScrollContainer/VBoxContainer.get_child(box_count+2).text)
							print("AG set to:" + pSingleton.player_capabilities[0].score)
						box_count = box_count+3
					"APP":
						print("Check: APP found!")
						if $ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.player_capabilities[1].score = str($ScrollContainer/VBoxContainer.get_child(box_count+1).text)
							print("AG set to:" + pSingleton.player_capabilities[1].score)
						box_count = box_count+2
					"CO":
						if $ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.player_capabilities[2].score = str($ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						box_count = box_count+2
					"QU":
						if $ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.player_capabilities[3].score = str($ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						box_count = box_count+2
					"MD":
						if $ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.player_capabilities[4].score = str($ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						box_count = box_count+2
					"ST":
						if $ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.player_capabilities[5].score = str($ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						box_count = box_count+2
					"CH":
						if $ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.player_capabilities[6].score = str($ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						box_count = box_count+2
					"EM":
						if $ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.player_capabilities[7].score = str($ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						box_count = box_count+2
					"IN":
						if $ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.player_capabilities[8].score = str($ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						box_count = box_count+2
					"ME":
						if $ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.player_capabilities[9].score = str($ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						box_count = box_count+2
					"MX":
						if $ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.player_capabilities[10].score = str($ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						box_count = box_count+2
					"PR":
						if $ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.player_capabilities[11].score = str($ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						box_count = box_count+2
					"RE":
						if $ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.player_capabilities[12].score = str($ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						box_count = box_count+2
					"SD":
						if $ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.player_capabilities[13].score = str($ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						box_count = box_count+2
				print("DEBUG, current box count is: " + str(box_count))
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
		
		for child_box in $ScrollContainer/VBoxContainer.get_children():
			is_label = child_box.get_class() == "Label"
			if is_label:
				var label_value = child_box.text.strip_edges(true,true).to_upper()
				match label_value:
					"NAME":
						if $ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.name = str($ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						print("TEMP name found! As : " + str(pSingleton.name))
						skip_next = true
					"PROFESSION":
						if $ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.profession = str($ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						print("TEMP prof found! As : " + str(pSingleton.profession))
						skip_next = true
					"QUOTE":
						if $ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
							pSingleton.quote = str($ScrollContainer/VBoxContainer.get_child(box_count+1).text)
						print("TEMP quote found! As : " + str(pSingleton.quote))
						skip_next = true
					_:
						skip_next = false
						char_labels.append(child_box.text.strip_edges(true,true).to_upper())
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
								new_cap.Game_Raw  = cap_item.text
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
				#Manually entered caps are in the game format, part of external char sheet
				new_cap.Game_toDisplay = false
				print ("Cap values saved as: " + new_cap.to_string())
				pSingleton.player_capabilities.append(new_cap)	
			elif !skip_next && child_box.get_class() != "PanelContainer":
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
#Prior system:
#		pSingleton.output_labels = char_labels
#		pSingleton.output_scores_A  = char_values_A
#		pSingleton.output_scores_B  = char_values_B
	#Output capabilities are created here, for general input. 
		var i = 0;
		for named in char_labels:
			if(char_values_A.size() >= i+1):
				var current = pSingleton.Capability_Source.new()
				current.Game_Name = named
				print("TEMP: name: " + named)
				current.Game_toDisplay = false
				current.Game_Value = char_values_A[i]
				current.Game_Extras = char_values_B[i]
				current.Game_Raw = str(char_values_A[i]) + "D+" + str(char_values_B[i])
				pSingleton.player_capabilities.append(current)
				i = i+1;
	#	Ref: char_sheet_converter (game:String, source_char:playerCharacterTemplate, char_in:bool)->playerCharacterTemplate
		pSingleton = GSP.char_sheet_converter(settings.game_selection, pSingleton, true)
	
#FUNCTION save character csv
#Params: none
#Returns: Nothing; all work done in function
#Notes: This saves the character output fields to a csv.
#	TO DO: this is not safe at all; we can't just take a player entered name
#		for a file name, we need to validate it. 
func _save_data_to_csv() -> void:
	var file_path = ""
	if str(pSingleton.name) != "":
		file_path = "user://" + str(pSingleton.name) + "_data.csv"
	else: 
		 file_path = "user://character_data.csv"
	var file = File.new()
	if file.open(file_path, File.WRITE) == OK:
		var csv_labels = ""
		#Prior system for labels:
#		for extra in pSingleton.output_extras:
#			csv_labels = csv_labels + extra + ","
#		for name in pSingleton.output_labels:
#			csv_labels = csv_labels + name + ","
		csv_labels = "Name,Profession,Quote,"
		for named_ability in pSingleton.player_capabilities:
			if named_ability.Game_Name != null && named_ability.Game_Name != "NA":
				csv_labels = csv_labels + named_ability.Game_Name + ","
		csv_labels = csv_labels + "\n"
		#Now print the values:
		csv_labels = csv_labels + str(pSingleton.name) + "," + str(pSingleton.profession)+ "," + str(pSingleton.quote)+ ","
		for val in pSingleton.player_capabilities:
			if val.Game_Name != null && val.Game_Name != "NA":
				if val.Game_Raw != null:
					csv_labels = csv_labels + str(val.Game_Raw)
				else:
					csv_labels = csv_labels + str(int(val.Game_Value))
					if val.Game_Extras != null:
						csv_labels = csv_labels + "D+" + str(val.Game_Extras)
				csv_labels = csv_labels + ","
		#Prior system for scores:
		#var labels_counter = 0
#		for val in pSingleton.output_scores_A:
#			csv_labels = csv_labels + str(val)
#			if pSingleton.output_A_label.length() > 0:
#				 csv_labels = csv_labels + str(pSingleton.output_A_label)
#			if pSingleton.is_output_B:
#				if pSingleton.output_B_label.length() > 0:
#					csv_labels = csv_labels + " " + str(pSingleton.output_B_label) + " "
#					csv_labels = csv_labels + str(pSingleton.output_scores_B[labels_counter])
#			labels_counter = labels_counter +1
#			csv_labels = csv_labels + ","
		#TO DO:add the values, too.
		file.store_string(csv_labels)
		file.close()
		print("Data saved to ", file_path)
		print(OS.get_data_dir())
	else:
		print("Failed to open", file_path, "for writing.")
		
func _on_Save_Button_pressed():
	_save_data_to_singleton()
	_save_data_to_csv()

#FUNCTION helper rem cap pressed
#Params: the parent node of the remove button being pressed
#Returns: Nothing; all work done in function
#Notes: Connecting to a capacity's internal button signal, this function's goal is
#	to remove the capacity on the button pressed from the character sheet. 
func _on_rem_cap_pressed(cap_par: Node) -> void:
	print("Connection made! Passed name is: " + cap_par.name)
	#var target_cap = $ScrollContainer/VBoxContainer.find_child(child_idx)
	$ScrollContainer/VBoxContainer.remove_child(cap_par)
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
	$ScrollContainer/VBoxContainer.add_child(new_cap)
	cust_cap_count = cust_cap_count+1
	print("Current count set to: " + str(cust_cap_count))
	#Get the remove button on the capacity node to connect signal:
	var cap_node_but = $ScrollContainer/VBoxContainer.get_child(cust_cap_count-1).get_child(0).get_child(0).get_child(1)
	#This sets the child count currently for future reference (to enable dynamic removes)
	cap_node_but.cap_setting = $ScrollContainer/VBoxContainer.get_child(cust_cap_count-1)
	cap_node_but.connect("rem_cap_pressed", self, "_on_rem_cap_pressed") 

func _add_capability_button() -> void:
	#Add a button to add new capacities at the bottom:
	var add_cap_but = Cap_New_Button.instance()
	add_cap_but.text = "Add New Capacity"
	add_cap_but.destinationLabel = "NA"
	$ScrollContainer/VBoxContainer.add_child(add_cap_but)
	if($ScrollContainer/VBoxContainer.get_child(cust_cap_count) != null):
		$ScrollContainer/VBoxContainer.get_child(cust_cap_count).connect("option_pressed", self, "_on_new_cap_pressed")
	cust_cap_count = cust_cap_count+1
