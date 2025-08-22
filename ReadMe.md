This is Carter's Weird Unnamed RTS Project.

Requires Godot compiled with double precision to work properly!


Unit: base for physical in-game objects
	modular components for things like ship hull, rudder, powerplant, weapons
	data is encoded in UnitData resources and loaded on ready()
Actor: a Node that can do things to Units and unit components
	Mover: attached to Units, handles the Unit's movement physics and move commands
	Group: attached to Players, handles order-of-battle, formations, etc.
Behavior: controls the stuff that Actors do
	at most one Behavior per Actor at a time
Command: an action that the user wants to happen
	includes adding, removing, switching, or modifying an Actor's Behavior


TODO:

	Save/Load
	
	Movement planner
		Destination marker
			Drag and drop on map
			Choose speed or time of arrial
			Calculate fuel consumption and flag if fuel insufficient
		Link destinations together
	
	Group Formations
		Column, Line, Circle, Freeform
		Group commands change individual unit behavior depending on formation
			Line ahead - column turn OR turn together (becomes line formation)
			Line - turn together
			Circle - turn together
		"Maintain formation" behavior
		"Move relative to formation" command
	
	Vision
		Fog of war - hide units not visible to local player
		Shared vision between players
	
	Add additional units
		Kongo, Haruna, Tone, Chikuma, Nagara, IJN DDs
		Yorktown, Enterprise, Hornet
	
	Aircraft
	
	LoL-style commands option (just press key while hovering over target)
	
	
