****************************
	README.TXT:
****************************
Author: Doug McCord
Date: 19-Mar-2023

****************************
Intro notes: 
	This is a basic menu for the MVP of the toolset, in order to test our various pieces from UML.


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

	globalScripts:
		For project-wide use, or scripts that are not either: 
			A. attached to a template scene, intended to go with all instances of that, or 
			B. unique, scene-specific scripts. 

	screens:
		Planned to include both .tscn scene files and their associated scripts. 

	userInterface: (note misnomer for text-based game)
		Re-useable UI elements and their scripts, such as change-scene, input-response
