class_name StatblockShip
extends StatblockUnit


@export_enum (
	"CV",	# Fleet aircraft carrier
	"CVL",	# Light aircraft carrier
	"CVE",	# Escort aircraft carrier
	"BB",	# Battleship
	"BC",	# Battlecruiser
	"CA",	# Heavy Cruiser
	"CL",	# Light cruiser
	"DD",	# Destroyer
	"DE",	# Destroyer Escort
	"AO",	# Fleet Oiler
) var ship_class: String

@export_group("Movement")
@export var hull_drag_coef: float
@export var rudder_drag_coef: float
@export var rudder_shift: float
@export var engine_power: float
