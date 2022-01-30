****************************
	README.TXT:
****************************
Author: Doug McCord
Date: 30-Jan-2022

****************************
Intro notes: 
	I created this to help explain the current Godot file structure I'm using. An 
	effort has been made to use a consistent organization, though it can most 
	definitely be improved/made more consistent.

****************************
Project file structure:
	Surface Layer:
		Game scripts are located at this level, included unique history scripts
			and the Game.gd script itself.
	_toArchive:
		Directory to serve as reference-only; precursor to trash

	assets:
		Images, fonts, TRES text resource data files

	globalScripts:
		For project-wide use, or scripts that are not either: 
			A. attached to a template scene, intended to go with all instances of that, or 
			B. unique, scene-specific scripts. 

	Screens:
		Additional scenes that are not the main game; includes both .tscn scene files and
			their associated scripts. 

	UserInterface: (note misnomer for text-based game)
		Re-useable UI elements and their scripts, such as change-scene, input-response
