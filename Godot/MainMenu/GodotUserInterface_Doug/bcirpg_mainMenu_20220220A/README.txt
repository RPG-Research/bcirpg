****************************
	README.TXT:
****************************
Author: Doug McCord
Date: 20-Feb-2022

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

****************************
Project file structure:
	Surface Layer:
		Default Godot files remain at this level

	_toArchive:
		Directory to serve as reference-only; precursor to trash

	assets:
		Images, fonts, TRES text resource data files

	globalScripts:
		For project-wide use, or scripts that are not either: 
			A. attached to a template scene, intended to go with all instances of that, or 
			B. unique, scene-specific scripts. 

	screens:
		Planned to include both .tscn scene files and their associated scripts. 

	userInterface: (note misnomer for text-based game)
		Re-useable UI elements and their scripts, such as change-scene, input-response
