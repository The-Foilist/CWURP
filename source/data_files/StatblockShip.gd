class_name StatblockShip
extends StatblockUnit


@export_enum (
	"Aircraft Carrier",	# Fleet aircraft carrier
	"Light Carrier",	# Light aircraft carrier
	"Excort Carrier",	# Escort aircraft carrier
	"Battleship",	# Battleship
	"Battlecruiser",	# Battlecruiser
	"Heavy Cruiser",	# Heavy Cruiser
	"Light Cruiser",	# Light cruiser
	"Destroyer",	# Destroyer
	"Destroyer Escort",	# Destroyer Escort
	"Fleet Oiler",	# Fleet Oiler
) var subtype: String

@export_group("Movement")
@export var hull_drag_coef: float
@export var rudder_drag_coef: float
@export var rudder_shift: float
@export var engine_power: float
