This is Carter's Weird Unnamed RTS Project.



Unit: base for physical in-game objects
	modular components for things like ship hull, rudder, powerplant, weapons
	data is encoded in UnitData resources and loaded on ready()
Actor: a Node that can do things to Units and unit components
	Mover: attached to Units, handles the Unit's movement physics and move commands
	FireControl: attached to Units, handles aiming and firing weapons
	FlightOps: attached to Units, handles launching, landing, and landed aircraft
	Group: attached to Players, handles order-of-battle, formations, etc.
Behavior: controls the stuff that Actors do
	at most one Behavior per Actor at a time
Command: an action that the user wants to have happen
	includes adding, removing, switching, or modifying an Actor's Behavior


TODO:
	"Approach" behavior and command for units and groups
	Group formations
		Group commands change individual unit behavior depending on formation
	"Move relative to formation" command
	Add BB, CA, CL, and DD to Kido Butai to test formations
	
