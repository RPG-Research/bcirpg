#CHARACTER_ADD:
#	Script for adding a new character and both saving it to file and loading 
#		it into the character object


extends Control

onready var settings = get_node("/root/GlobalSaveInstance").settingsInstance
onready var pSingleton = get_node("/root/PlayerCharacter").pc

#GSP is to hold instantiated GSP_Layer; needed for calling necessary conversion functionality
const Game_Layer := preload("res://globalScripts/GSP_Lookups.gd")
onready var GSP = Game_Layer.new()


func _ready() -> void:
	theme=load(settings.themeFile)
	$Title/But_SaveChar.grab_focus()
	_populate_output_character_format()

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
		$Title/ScrollContainer/VBoxContainer.add_child(setLine)
		var setBox = LineEdit.new()
		$Title/ScrollContainer/VBoxContainer.add_child(setBox)


	#DKM TEMP (12/22/24): Putting in direct access to the percentile system, as 
	#	the Capabilities system is tested. These values should be set on the GSP as
	#	per all systems. 
	if (settings.game_selection == "BCIRPG_PERCENTILE"):
		pSingleton.is_output_B = false
		pSingleton.output_A_label = ""
		for label in pSingleton.source_backend_capabilities:
			var textLine = Label.new()
			$Title/ScrollContainer/VBoxContainer.add_child(textLine)
			textLine.text = label + ":"
			var textBox = LineEdit.new()
			$Title/ScrollContainer/VBoxContainer.add_child(textBox)
		#Here: add interactive capacity to add new capabilities. 
		
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
	var char_labels = []
	var char_values_A = []
	var char_values_B = []
	
	var is_label = true
	var skip_next = false	
	var box_count = 0
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
	pSingleton.output_labels = char_labels
	pSingleton.output_scores_A  = char_values_A
	pSingleton.output_scores_B  = char_values_B
				
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

