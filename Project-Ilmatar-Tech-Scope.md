# Project Ilmatar Tech Specs Doc
by Hawke Robinson

This is a snapshot of the BCI RPG "Project Ilmatar" project technical specifications document. This snapshot was from the October 1st, 2023 revision. This will be updated periodically as resources allow. This will need major cleaning up to fit within the .md format properly.

# PROJECT ILMATAR

RPG Research

ERPG Dev Team

Created on 10/13/19


# REVISION HISTORY


# DATE
2024/03/10

# VERSION
0.0.3 

# DESCRIPTION
    

#  AUTHOR
Hawke Robinson
    

# Base Specifications - Phase 1
    

Valerie, Hawke
8/22/2020
    

# Base Specifications - Phase 2
    

ERPG Dev Team
10/1/2020
0.0.3
    

# Section/Layout/Organization adjustments for clarity
    

Valerie Krepel
10/24/2020
0.0.4
    

# Integration with agenda notes, define features
    

Valerie Krepel

2/08/2021
    

0.0.5
    

# Integration with agenda, define features and terms
    

Valerie Krepel

9/26/2021
    

0.0.6
    

# Integration with agenda, elaborations on solutions
    

Valerie Krepel

6/5/2022
    

0.0.7
    

# Integration with agenda, additional solutions
    

Valerie Krepel

7/2/2023
    

0.0.8
    

# Integration with agenda, server ports
    

Valerie Krepel

10/1/2023
    

0.0.9
    

# Integration with agenda, database options
    

Valerie Krepel
            
            
            
# INTRODUCTION


## Overview

This project came about because of multiple client requests over the decades to provide an ERPG solo and multiplayer experience similar to the TRPG experience. This was further developed when Hawke worked with some specific clients but was set aside when the client was incapacitated by a brain injury. The demand, however, for ERPGs that can be tweaked to meet specific measurable goals for different populations to achieve their recreational, entertainment, educational, professional, and therapeutic needs.

# Glossary or Terminology

New terms you come across as you research your design or terms you may suspect your readers/stakeholders not to know.  

Flowchart - Diagram used to mimic code logic before programming, split into diagrams for different processes.

Game Masters - Those who interact with the finished,playable side of the product with limited amounts of control over the gameplay (i.e. control over NPCs, Monsters, and certain elements of the environment).

Game System Contributors - Those who contribute to limited elements of the game, as in certain systems, but have not been responsible for helping to build the full project.

Mod Gods - Those who create modules for use by players and/or game masters. Note: mod god is not exclusive, a player or a game master can also be a mod god.

MVP - Minimum Viable Product. The baseline of features needed to have the basic structure of our program.

NPC - Non-playable character. A character in the game system who cannot be controlled by players and has to be entirely coded by the Mod Gods in terms of dialogue and actions.

NWN - Neverwinter Nights, a game by bioware which includes the Aurora Toolset, a game building tool that has a function similar to how we’d like our game creation toolset to run.

Players - Those who interact with the finished, playable side of the product.

Software Development Team - Those who have built the product and worked on multiple/overarching aspects of the software.

Use-Case Wireframe - a more detailed version of a wireframe, including real game scenarios and text.

Wireframe - a mockup of the user interface for the game -- NOT the same as a flowchart.

# Project Scope

The triangle of resources between time, quality, and expenses (man hours and other costs). While this project does not have a set timeline, we do want to use project best practices to try to keep the momentum going.

    Regarding quality, we are concerned about functional quality but not so much aesthetic quality. The user interface, animation, and graphics don’t need to be high end, just functional enough to meet the goals. We do want code quality to be high: bug-free, well-tested, stable, not a resource hog, and cross-platform with easy to maintain code.
    Regarding time, though no set timeline, we will set regular monthly goals to strive for and periodic roadmap milestones.
    Regarding manpower and finances, this is a volunteer-based project. We may open it up to the general public under open source licensing for additional help. We may be using someone else’s open source framework if we can find one that matches. We currently have about half a dozen people on staff interested in helping with the development and testing, which will be listing in the project management documents and updated by the PM monthly. The current project director is Valerie Krepel with guidance from Hawke Robinson.



Multiple stages to development:   

    Stage 1: NWN Mod1 on NeverwinterNights Aurora Platform ESMA (electronic solo or multiplayer adventure)

RPG

    Stage 2: Ilmar text only branching ETSMA (electronic text-based solo / multiplayer adventure) RPG
    Stage 3: Vaina (pronounced: Vah-een-ah) activated live action film or animation based on Stage 2’s result,
    Stage 4: 
    Stage 5: 
    Stage 6:  

# Interactive video plus (IV+)



# MVP for Base Toolset (Phase 2)

    Very basic graphical/text tool that allows us to create a gamespace with some minimal drag and drop functionality (similar to aurora toolset). 
    16 x 16 grid space that we can drag and drop tools into space.
    Tools: event trigger. Dialogue pop-up with menu option. No limits to number of items in menu (2-3 for prototype but don’t limit for later). Branching logic opportunity. Condition can be set based on a decision made from menu options (if b, set condition, if c, set condition, etc.). Export module feature. Open module, new module, save module, save as.
    Scenes
        Scene tag/title
        Starting node
        Default image -- need tag to be dynamic?
        Set genre/location
        Have overarching scene map to connect each scene to each other
    Object Creation 
        Modify Godot sounds with our software?
        Select sound/import sound
        When sound play? At beginning, with delay? When text reaches certain point?
        Volume
        Duration? Looping?
        Sound continues into another screen -- how determine this? Toggle on each individual screen? Determine all screens w/in the one sound menu? 
        Description - GENRE
        Damage
        Name - GENRE
        Have default name that fills in any genres that are blank for this object. Do not return blanks.
        Object can not be unnamed. Weapon form will not allow weapon to be created without name -- will need to check to ensure same weapon name is not used more than once.
        Name / description - GENRE
        Modifier/ target stat
        Charges boolean (if finite item) + number
        Weight (even if don’t implement, have option to)
        Special tags? Used to trigger events, etc. interactions that need item. Program assigns number
        Can store other things? How many inventory slots.
        Resale value
        I.e. magic/spells, power ups
        Classes vs. skills -- spend upgrade points where you want. Remove class choice as option, and system will determine your class. Have generic class? Have class system in place, but create a class where you can assign your own points as needed. If system does not have class, use generic
        Review Rolemaster as possible basis for abstracted percentage stats.
        Have class editor so you can make classes if desired but classes are not required. - GENRE
        Body type -- can incorporate into class that gives you modifiers/limitations
        Inventory slots -- how much can character carry? 
        Weight/encumbrance --  boolean + integer. Increase with stats?
        Toolset character creation is primarily for npcs, the player character creation is more beefy. 
        Name
        Trigger - set conditions
        Risk factor assignment
        Toggle for scene change and link to scene. Load level -- optimize load time
        time/turn? 
        Description of event
        Any kind of puzzle, turn or time events fit into this category. Node that breaks from rest of map and returns you to map once you have completed the course.
        Associated with abilities/weapons?
        Sounds
        Weapons
        Items
        NPCs -- stored in object after being created in character process
        Special Abilities
        Characters (character creation for both player characters and simplified version for NPCs)
        Events/Risk Factors/Scene Changes
        Class Editor
    Basic functions for editors
        Check item, take item, give item, stats impact (+/-), start combat, go to location
    Madlibs/Genre Substitution -- xml mapping file that allows for values and use to sub in madlibs
    Grammar 
    Dialogue
        Nest layers of dialogue
        For example, create world. Section that is being filled in is the part that is assigned the new pieces. When do exports, imports, syncs, use directory instead of requiring complete changes to entire structure. 
        Dialogue script for each invocation? Don’t want massive dialogue file for each convo that happens. Want to keep things in bite-sized pieces, worry about indexing and performance later. 
    Ability check add on for code
    Default scripts (such as ammo consumption) to be added for general use. Room for mod gods to create their own scripts.
    For the MVP 1.0  Server and Game Creation and Management Toolsets, we only need them to work on Windows, Mac, and Linux (Desktop app and headless server functions).

# Phase 2 Menu Items

    Light/Dark mode toggle
    Use the phrase ‘Import Character’ as opposed to ‘Add Character’ to prevent confusion
    GM preferences
        Player limit
        Add or remove characters from campaign as needed
        Create character
    Player preferences
        Fitale layout/Central-biased
        Qwerty
        Alphabetical
        Corner-biased layout
        Risk factors
        Volume
        Brightness 
        Display name (for GM to see)
        Character creation full toolset. Characters saved as ini that can be accessed in toolset. Modified version for npcs in toolset.
        Closed captioning on/off for sounds.
        Remap controls -- godot has input remapping
        Font size
        Default bg color/image
        Keyboard

# Non-Goals or Out of Scope

    Future Goals

    Player timer for each decision that can store extra time to be used later
    Select genre and open source option and it will take the same adventure in terms of storyline but equipment, weapons, etc. will be diff depending on selected genre
    Make using the toolset as part of the opening menu so you can select gameplay or moving into creating own game
    Perpetual world support
    Add more branches than 3
    Real-time monitoring of players’ progress (spectator mode)
    Audio and video chat
    For 2.0, party viewpoints can be split
        Don’t split too far to prevent big issues
    Group voting/consensus (2.0)
    Choose between railroaded or sandbox-ey
    Therapy/educational/entertainment tags (learning mode settings)

# Assumptions

# Conditions and resources that need to be present and accessible for the solution to work as described. 

# Notes on Comparable Items

# Compare between comparable softwares. What do we like? What do we dislike? Would we like to create our own version of certain features?

# Aurora Toolset Module Editor

    Hard to tell when conversations branched. Coding vague at best and a big pain to integrate. Split up dialogue conditionals -- clearly separated. No indication if line overflows, have to look elsewhere for full text. Too many functionality buttons.
    Like difference in color between npc and pc. Idea of base + branches good (might need to be split?) Node based? May need to find code for it so we don’t have to build it ourselves

# SOLUTIONS

    Proposed Design 

# Features

    Platform that allows solo and multiplayer adventures
    Built in some kind of open source license that mandates attribution and does allow commercial use with permission.
    Development tools must allow this kind of use.
    Use some kind of version control (GitHub or other)
    Public download use
    Use Open D6 as starting game system
    Run on as many platforms as possible (starting with PC)
    Functions on a network
    Can be played in multiplayer, single/solo, or client mode
    For 1.0 MVP we need all game PLAY functions to work on all platforms including web (Windows, Mac, Linux, iOS, Android, and Web) and be fully BCI usable. 

# Project Overview

# The project is a combination of module editor and playable game.

# Game

The game will consist of playable modules with storylines that encourage players to make decisions based on non-violence, exploration, problem-solving, and compassion. Players may create their own module outside of this scope, but our team will be operating with these goals. 

Each module will be playable in multiple genres -- to start, our modules will have options to be played in fantasy, sci-fi, or realistic modern fiction. More genre options can be added. Genre will be integrated via mad-libs style inserts -- for example, a weapon could be tagged as crossbow in fantasy, laser gun in sci-fi, and revolver in modern fiction. The statistics of each item will be abstracted from the genre tag.

Game text will let a player know the outcome of their rolls in a way that is not obstructive to storytelling and immersion. For example, if a player’s strength statistic is not high enough for the action they attempted to make, game text would read along the lines of ‘You tried to do [action], but your body was too weak! You take 1 hp of damage.’

# Player Objections

Players will be given the option to object to decisions made by other party members if they disagree. Players will be able to set a ‘risk rating’, which will determine which of the other players’ choices they will be able to object to; the game will be set to the middle risk level as default if the player does not choose for themself. All game choices will be given a rating as set by the mod god. Those who have chosen a higher risk rating threshold will not be given the choice to object and will automatically proceed with the decision of the player making the primary choice.

The player making the choice will be shown the number of objections, and all players will be given the opportunity to break out into chat to discuss, even if some players did not object. After discussion, players will be given the same choice again and those who choose differently from the original choice that was objected to will abstain from that action and its consequences or rewards. If there are no objections, the game will continue with no further discussion.

# Chat

The game will have an integrated chat function. Audio chat may be tricky, but there is a possibility of linking into Jitsi or a similar 3rd party service. Text chat will be included as a minimum, but will not integrate well with BCI, so audio chat is a goal as well. Players in group settings will need to be able to communicate with one another to make decisions, form strategies, discuss puzzles, etc. For BCI accessibility, chat will have an ‘enable’ toggle. When the toggle is off, chat will be readable but not interactable. When it is on, chat can be written in.

# Behavior Guidance

Modules will present problems with various decisions, each decision tagged on a gradient of good-neutral-bad. At the end of the module, the outcome will be determined by the group (or players) gradient levels, with good levels resulting in the best possible outcome, bad in the worst possible outcome, and neutral somewhere in between. 

Players will receive little feedback dialogues throughout the game to let them know if they are on a good, neutral, or bad track so they can adjust accordingly. The feedback will be integrated with the game so as to not break immersion. Towards the end of the module(s), players will be blatantly told which track they are on and will be given one last major decision to alter their route.

Once the module is finished, there will be a report of decisions and paths taken by the player. Players can view parts of the report, but not all (we want to avoid the players making decisions simply because they saw it will give them a better end in the report). Administrators/Game Masters can view full, printable reports, which will include player statistics and tags determining whether players are leaning toward violent decisions or not.

# Initiative and Turns

For combat, players will select options at the same time and will go in order of violence, starting with least violent and going to most. For example, players who choose to negotiate will go before players who choose to fight. Players later in the action queue may change their mind and choose a different option based on the outcomes of previous players’ choices -- i.e. Player one chooses to negotiate and is mostly successful. Player two had chosen to fight but may change their mind and choose to continue negotiation or any other option when their turn arrives. See extended contested conflict flowchart.

For non-combat, there will be a random assignment using process of elimination with an opt-out feature. Players will be put into a pool and names would be randomly selected, then removed from the pool. Once the pool is empty, the process would repeat -- all players would get an equal number of turns, but order would be randomized. There will be temporary exclusion to prevent the same player from going twice in a row, as well as the option to opt out of making choices each round. Should all players opt out, the default is for everyone to be put into the selection pool again and a buffer to be applied to the party’s decision, meaning any NPCs in the presence of the party will take their turns first. The code will need to be tolerant of drop in/drop out players.

# GM Permissions

GMs will have the same base code as players but with added accessibility and editing capabilities.

    The physical world (of the game world) items (treasure, traps, etc.) and creatures/NPCs - but does NOT have the ability to change terrain, building structures, etc.). Can change weather, time of day. This shouldn't need to interface (much?) with the Game Abstraction Layer (GAL).
    The meta of the game (providing XP/levels, etc. This will have to be heavily linked to the GAL.
    If the GM starts the player client, they can join the game asa  normal player, or they can join as an observer. Then whether in normal player mode or observer mode, if they have the DM Password for the server, they can enable a checkbox to enable "DM Mode" (aka Semi-ModGod mode). This then makes calls to classes/functions available to the user that are not available to a normal player.

Many GM features will be similar to NWN but with different approaches.



# Module Editor

In addition to the included modules, players will have the options to create their own to play. The module editor will take inspiration from the Aurora Toolset, with some differences.

The editor will be in a drag-and-drop grid style to make editing easier. It will be a very basic graphical/text tool that allows us to create a gamespace with some minimal drag and drop functionality. Minimum included tools will be:

    Event trigger
    Dialogue pop-up with menu option
    Export module
    Open module
    New module
    Save module, save as
    Genre editor

# Minimum included features will be:

    No limits to number of items in menu (2-3 for prototype but don’t limit for later) 
    Branching logic opportunities
    Condition can be set based on a decision made from menu options (if b, set condition, if c, set condition, etc.)

Included in the module editor will be objects organized by entity type. Objects will be presented in the module editor as base items without any genre-specific names or statistics; these attributes will be customized by the mod gods to fit the needs of the individual modules. Also included are wizards for object creation. These wizards will include: 

    Scenes
    Sounds
    Weapons
    Items
    Character Creation (including NPCs)
    Events/Risk Factors/Triggers
    Genre Substitution

In order to assist with testing and genre-substitutions, a ‘dummy’ NPC will be placed in the game for testing primarily. This character can be removed from the playable game but not from the toolset dock.

To set up scenes, areas must be arranged in the following order (with examples):

    Select/create preferred Genre: Fantasy, Scifi, Modern/Contemporary (impacts he "Madlibs" selections for nouns, verbs, adjectives, etc.).
    Select/create Preferred Campaign/Setting (Middle-earth, Greyhawk, Dune, COPS, etc.)
    Select/create (RPG) Game System (d20, d6, D&D, etc.)
    Select/create Module/Adventure (Kings Ransom, Benders Bender, In Search of the Missing Surgeon, etc.)
    Region (Kingdom of Furyondy, Moon, New York State, etc.)
    Location (Verbobonc, Lunar Colony 3, Manhattan Island, etc.)
    Space/Room (Brass Rail Tavern/Bedroom2, Sector 5/room 103, Empire State Building 5th floor lobby, etc.)
    Scene (Bar room brawl #4, Radiation leak #2, chase scene #7, etc.)

Each overarching section can affect and feed into the more granular areas. So Region of alpine mountains may trigger dialogue like ‘the area is cold and covered in snow’ whereas scene specifies events. Less granular areas would not be affected by more granular areas.



# Game System-agnostic

The module editor will determine rolls based on percentages, not dice types, so the editor will be agnostic in terms of game systems. The Mod Gods can determine which game system they want to base their rules off of and customize the module to fit (i.e. using OpenD6 or D&D 5th Edition). Likewise, statistics can be added, removed, or renamed to fit statistics held in differing game systems.

The default agnostic system employed will have base stats that cannot be removed but can be renamed based on the system the Mod God would like to use. Additionally, the default does NOT have level advancement or classes, but the Mod God can customize their system to include it.

# Softwares Needed to Attain

Coding repository: Github

To be used for communication, sharing of files, and documentation.

Branching narrative: Twinery

To be used for the creation of our branching narratives. This narrative tree will then be taken into the Aurora Toolset for Phase 1, then into the following phases as our demo project.

Game Engine - decision: Godot

Money: open-source; must be affordable if not free. $100/developer seat limit max

Man-hours: with limited staff, more features means much more development time

To be used as base game engine for Phase 2. Godot is the only software found after extensive research that matches requirements: 

    Mac, LInux, Windows developer environment
    Mac, Linux, Windows, Android, Web end user platforms. iOS on wishlist but not required.
    A commonly used developer language (Godot supports C++)
    IDE support
    Open source licensing
    Accessibility support
    Localization support as a plus
    Accept media - video, sound, graphics, possibly special text
    Community support
    UML support as a plus.
    Reality support as a plus.

Wireframe software: Diagrams.net

To be used to create code wireframes (hopefully in UML). After research, diagrams.net best fits our needs for the following:

    Open source licensing
    Collaboration options (real-time, commenting, or ability to share docs)
    Ability to simulate UI
    Ability to wireframe code
    Exports to common files
    Links with github
    Non-limiting number of users
    No debilitating limitations (i.e. number of documents, number of allowed objects)
    Free
    Supports local hosting, not just cloud

# Flowchart Standards

First letter of each word in a title to be capitalized, with title in upper right hand corner of the document in a line.

Developer IDE - decision: XCode for Mac, Visual Studio Community for Windows, see if Eclipse is an option for Linux

Data Storage: RE-EVALUATING

JSON can be used for data storage for client-side, but move to another for server-side. Note for usage: Need .ini file in backend so mod gods can customize their modules. Streamline this process for the mod god so they don’t accidentally end up in the software code. Options determined in this file can override JSON, deleting this file will return to the default provided. If blob is bigger than 1 mb, write to file system and instead use a link where it is in the file system.

SQLITE can be used for dialogue.

MariapDB, MongoDB, PostQSQL all in consideration. Documentation for options:

Mongo: https://3ddelano.github.io/mongo-driver-godot/examples/ 

Godot's Postgres Plug in, please use this template to help set up your DB connection: https://github.com/Marzin-bot/PostgreSQLClient/blob/main/Helloworld.gd  

Chat Service - decision: TBD

Ideally, hook the back end of chat in through Matrix-Synapse. This may mean the front end will have to be our own code.

Dialogue framework: TBD

Procedure

Create the toolset first -- look at default godot options for how to play the game. Give the data file that runs the game to godot. Design of toolset will dictate what engine needs to include- minimum viable product for toolset, using NWN as guideline. 

Will need to learn godot to understand interaction. Toolset for design, right code for toolset, right code for engine. GUI pseudocode to engine features to prototype GUI.

Create MVP with basic toolset features to verify attainability.

    Very basic graphical/text tool that allows us to create a gamespace with some minimal drag and drop functionality (similar to aurora toolset). 16 x 16 grid space that we can drag and drop tools into space.
        Tools: event trigger. Dialogue pop-up with menu option. No limits to number of items in menu (2-3 for prototype but don’t limit for later). Branching logic opportunity. Condition can be set based on a decision made from menu options (if b, set condition, if c, set condition, etc.). Export module feature. Open module, new module, save module, save as.
    Micro MVP for game to play: works on a network. In server multiplayer mode, single/solo player mode, client mode. Show to 2 or more players the same menu screen on event trigger. Last person to connect gets the first choice, rotate which players choose i.e. 5, 4, 3, 2, 1, 5. Have each dev do their own version of this to get a better idea of the pros and cons of the toolsets. 

# Documentation

If Java-based, use Java doc.

Use GitHub for code sharing / versioning. Use GitHub Wiki for documentation: default is manager can edit but all can view. Documentation to be maintained actively as the project progresses. 

For importing and exporting, use LibreOffice default formats so all parties can get access.

Pseudocode

Wireframes

Directories

https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard

Standard Directory Structures for filepaths

https://en.wikipedia.org/wiki/X.500

New module follows directory, creates new room for current module, sorts into hierarchy based on mod god declarations. Then see config file, directories for dialog folder, maps folder, audio, etc all distinctive to that specific location. Can do inheritance by invoking name and then modifying difference in inheritance.

ROOT INSTALL DIR: /usr/local/games/bcirpg

Windows install dir: C:\PROGRAM Files\Applications\BCIRPG

for Windows C:\Users\username 

mac OS uses unix

Linux install dir: USER HOME = /home/username 

$GAMEDIR = <os-based-path>/BCIRPG/ 

Relative filepaths:

$GAMEDIR/data 

$GAMEDIR/bin 

$GAMEDIR/user 

$GAMEDIR/user/characters 

$GAMEDIR/data/gamesaves 

$GAMEDIR/data/csv 

$GAMEDIR/configs 

$GAMEDIR/data/sqlite 

$GAMEDIR/modgod 

$GAMEDIR/bin/modgod (the executable) 

$GAMEDIR/data/modgod/modules 

Local development environment server:

Ssh [username]@srv1.bcirpg.com

Privileged ports open for  22 (ssh) http (80) and https (443)

Non-privileged ports 8080-8099 for dev use

User requirements

Run on Linux, Mac, Windows, Android (phase 3 ideal: web).

Test Plan

Explanations of how the tests will make sure user requirements are met

Unit tests

Integrations tests

QA

For Version Manager, testers can use whatever you want, as long as it is explicitly noted at the top of every test which VM and version were used.



Monitoring and Alerting Plan 

Logging plan and tools

Monitoring plan and tools

Metrics to be used to measure health

How to ensure observability

Alerting plan and tools

Release / Roll-out and Deployment Plan

Deployment architecture 

Deployment environments

Phased roll-out plan e.g. using feature flags

Plan outlining how to communicate changes to the users, for example, with release notes

FURTHER CONSIDERATIONS

Third-party services and platforms considerations

Is it really worth it compared to building the service in-house?

What are some of the security and privacy concerns associated with the services/platforms?

How much will it cost?

How will it scale?

What possible future issues are anticipated? 

Cost analysis

What is the cost to run the solution per day?

What does it cost to roll it out? 

Security considerations

What are the potential threats?

How will they be mitigated?

How will the solution affect the security of other components, services, and systems?

All network connections are encrypted.

All passwords are kept in an encrypted or hashed format, no clear text passwords.

Inter-server, inter-user all encrypted.

Implement from the beginning because it will be needed in later Phases. 

Privacy considerations

Does the solution follow local laws and legal policies on data privacy?

How does the solution protect users’ data privacy?

What are some of the tradeoffs between personalization and privacy in the solution? 

Regional considerations

What is the impact of internationalization and localization on the solution?

What are the latency issues?

What are the legal concerns?

What is the state of service availability?

How will data transfer across regions be achieved and what are the concerns here? 

Accessibility considerations

How accessible is the solution?

What tools will you use to evaluate its accessibility? 

Operational considerations

Does this solution cause adverse aftereffects?

How will data be recovered in case of failure?

How will the solution recover in case of a failure?

How will operational costs be kept low while delivering increased value to the users? 

Risks

What risks are being undertaken with this solution?

Are there risks that once taken can’t be walked back?

What is the cost-benefit analysis of taking these risks? 

Support considerations

How will the support team get across information to users about common issues they may face while interacting with the changes?

How will we ensure that the users are satisfied with the solution and can interact with it with minimal support?

Who is responsible for the maintenance of the solution?

How will knowledge transfer be accomplished if the project owner is unavailable? 

SUCCESS EVALUATION

Impact

Security impact

Performance impact

Cost impact

Impact on other components and services

Metrics

List of metrics to capture

Tools to capture and measure metrics

WORK

Work estimates and timelines

List of specific, measurable, and time-bound tasks

Resources needed to finish each task

Time estimates for how long each task needs to be completed

Prioritization

Categorization of tasks by urgency and impact

Milestones

Dated checkpoints when significant chunks of work will have been completed

Metrics to indicate the passing of the milestone

Future work

List of tasks that will be completed in the future

DELIBERATION

Discussion

Elements of the solution that members of the team do not agree on and need to be debated further to reach a consensus.

Open Questions

Questions about things you do not know the answers to or are unsure that you pose to the team and stakeholders for their input. These may include aspects of the problem you don’t know how to resolve yet. 

Hook into Jitsi (open source) if possible. Text chat as minimum but won’t work with bci so audio would be nice https://www.youtube.com/watch?v=7c7aZTUITD4

For prototype, can’t split the party to limit viewpoints. For now, other players can watch decisions made by their teammates

Scope out toolset specs - multiple subphases.

Minimum viable product, plus incremental additions.

Suggested Project Additions

Approved parts of the project that need additional information before being fully implemented into the Solutions section.

In menu options, should have option to help another pc

If playing solo, remove option

End Matter

Related Work

Any work external to the proposed solution that is similar to it in some way and is worked on by different teams. It’s important to know this to enable knowledge sharing between such teams when faced with related problems. 

## REFERENCES

Links to documents and resources that you used when coming up with your design and wish to credit. 

## UML Tutorials

    https://medium.com/nerd-for-tech/principles-of-object-oriented-design-556edf6987be
    https://www.oodesign.com/design-principles
    https://www.visual-paradigm.com/guide/uml-unified-modeling-language/uml-class-diagram-tutorial/
    https://www.educative.io/courses/grokking-the-low-level-design-interview-using-ood-principles  (paid tutorial)
    https://creately.com/blog/software-teams/class-diagram-tutorial/
    https://www.educba.com/class-diagram/
    https://blogs.sap.com/2022/05/27/abap-oo-design-7-basic-oo-principles-summary/ 


## Acknowledgments
In alphabetical order by first name first:

* ...
* Doug  (Developer, …)
* ...
* Hawke Robinson (Project founder, lead researcher, developer)
* ...
* Luke (Developer, …)
* ...
* Suhwan (Developer, ...)
* ...
* Trevor Tengowski (Developer, …)
* ...
* Valerie Krepel (Project Manager, …)
* ...




