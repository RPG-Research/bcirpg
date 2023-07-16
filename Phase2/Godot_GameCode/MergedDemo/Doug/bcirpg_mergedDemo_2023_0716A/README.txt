****************************
	README.TXT:
****************************
Author: Doug McCord
Date: 16-July-2023

****************************
Intro notes: 
	This menu was stripped down from the bigger game and settings testing 
	I was doing -- so there's a decent chance yet of something broken -- 
	please let me know if you encounter anything that's not linking up as 
	desired. Currently there are temp destinations loaded for each of the 
	menu options -- these are saved as scenes in the screens folder.

	Currently almost all the buttons are instances of the same source 
	button object -- linked to their destination using the 'Next Scene Path'
	available in the inspector.

	*Updated the userInterface and screens directory names on 16 July, 2023 to 
	be UserInterface and Screens and made additional fixes in the attempt to 
	resolve case name issues between Win/MacOS and Linux. 


****************************
Project file structure:
	Surface Layer:
		Default Godot files remain at this level

	_toArchive:
		Directory to serve as reference-only; precursor to trash

	assets:
		Images, fonts, themes and styles (TRES text resource data files). Note that all fonts and styles are defined in 
			the following themes: ui_controlNode_light_theme.tres and ui_controlNode_dark_theme.tres. Any style changes
			should be made in those theme files to assure propagation throughout.

	gamePlay:
		Scenes and scripts specific to the gameplay section

	globalScripts:
		For project-wide use, or scripts that are not either: 
			A. attached to a template scene, intended to go with all instances of that, or 
			B. unique, scene-specific scripts. 

	screens:
		Planned to include both .tscn scene files and their associated scripts. 

	userInterface: (note misnomer for text-based game)
		Re-useable UI elements and their scripts, such as change-scene, input-response
