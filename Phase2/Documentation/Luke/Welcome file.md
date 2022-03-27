# Welcome to Project Ilmatar!

Hello, This is Luke's Documentation for **Project Ilmatar**. This will be a way to get a reference as to what is going on under the hood of my portions of code so far.

# Die Roller ///Die.gd///

The Die roller I created is based on an *emum* datatype called **DieCategory**. This die roller will take in the Parameter of the Die type you want to roll. It will then seed a random number generator and create a die outcome that is appropriate to the die type chosen.

1. First, you need to set the DieType variable to one of the vars inside of DieCategory. Example DieCategory.D00. 
2. Then you must call SetNumberOfSides(), this will prime the die roller to have the correct DieType.
3. Then you can call RollDie(NumberOfFaces), to roll the die; and return a value and a success rate in terms of a %.


# Save and Load Game ///SaveAndLoadGame.gd///

This version of the save and load game system, requires SQLite.
The implementation is a basic test at the moment, but full functionality should be able to be added as the projects data increases.

To use SQLite you will need to use the SQLite plugin for Godot from 2Shady4u *It's trust worthy, despite the name*....

You will also need to install DBBrowser for SQLite. This will allow you to create table objects, which you will then enter data into using Godot.


# Date And Time ///Date.gd///
This class is an extension of Date.gd from vanskodje-godotengine / godot-plugin-calendar-button .

This class allows for you to read date and time objects. 

Ideally this class will be used to give time stamps for how old save games are.

Could also be used to set in game timers and time limits, as well.







