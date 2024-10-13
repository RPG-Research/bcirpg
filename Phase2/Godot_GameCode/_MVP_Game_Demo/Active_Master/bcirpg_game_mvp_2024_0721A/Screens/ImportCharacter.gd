#GRAB FOCUS: simple script for temp files to grab focus
#	Expanded for Import Character option

#DKM TEMP: TO DO: As with the character add, we need this to read what's 
#	handed to it and generate the output from that, rather than have this be hard-coded. 

extends Control

onready var settings = get_node("/root/GlobalSaveInstance").settingsInstance
onready var pSingleton = get_node("/root/PlayerCharacter").pc

#GSP is to hold instantiated GSP_Layer; needed for calling necessary conversion functionality
const Game_Layer := preload("res://globalScripts/GSP_Lookups.gd")
onready var GSP = Game_Layer.new()

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
	for label in pSingleton.output_labels:
		var textLine = Label.new()
		$ScrollContainer/VBoxContainer.add_child(textLine)
		textLine.text = label.to_upper()
		i = i+1
		#match to content, assuming it exists and aligns
		if(pSingleton.output_scores_A.size()>= i):
			var textBox = LineEdit.new()
			$ScrollContainer/VBoxContainer.add_child(textBox)
			
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
		for i in csvStrHeaderArray.size():
			#make a new textbox for each header piece
			var textLine = Label.new()
			$ScrollContainer/VBoxContainer.add_child(textLine)
			textLine.text = csvStrHeaderArray[i].to_upper()
			
			#match to content, assuming it exists and aligns
			if(csvStrContentsArray.size()>= i):
				var textBox = LineEdit.new()
				$ScrollContainer/VBoxContainer.add_child(textBox)
				textBox.text = csvStrContentsArray[i]
	_save_data_to_singleton()
	
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
	var char_labels = []
	var char_values_A = []
	var char_values_B = []
	
	var is_label = true
	var skip_next = false
	var box_count = 0
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
				"WEAPON":
					if $ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
						pSingleton.weapon = str($ScrollContainer/VBoxContainer.get_child(box_count+1).text)
					print("TEMP weapon found! As : " + str(pSingleton.weapon))
					skip_next = true
				"ARMOR":
					if $ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
						pSingleton.armor = str($ScrollContainer/VBoxContainer.get_child(box_count+1).text)
					print("TEMP armor found! As : " + str(pSingleton.armor))
					skip_next = true
				"QUOTE":
					if $ScrollContainer/VBoxContainer.get_child_count() >= box_count+1:
						pSingleton.quote = str($ScrollContainer/VBoxContainer.get_child(box_count+1).text)
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
	pSingleton = GSP.char_sheet_converter(settings.game_selection,pSingleton, true)
	
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
		for name in pSingleton.output_labels:
			csv_labels = csv_labels + name + ","
		csv_labels = csv_labels + "\n"
		csv_labels = csv_labels + str(pSingleton.name) + ","
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
		
func _on_Save_Button_pressed():
	_save_data_to_singleton()
	_save_data_to_csv()
	
