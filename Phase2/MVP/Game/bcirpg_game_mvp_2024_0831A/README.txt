****************************
	README.TXT:
****************************
Author: Doug McCord
Date: 4-Feb-2024

****************************
Intro notes: 
	This project updates the RPGR BCI merged demo game from August 6, 2023 for
	the Modgodtoolset and associated updates. Draws game from XML, and adds 
	numerous missing features. 

	The roadmap for this file can be found in the project Github:
		Phase2/Documentation
		


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
