class_name StatblockAirplane
extends StatblockUnit

@export_enum(
	"Fighter",			# single engine prop figher, or jet
	"Heavy Fighter",	# twin engine prop fighter
	"Dive Bomber",		# single engine dive bomber
	"Attack Plane",		# single engine, level or torpedo bomber
	"Medium Bomber",	# 2/3 engine level bomber
	"Heavy Bomber",		# 4 engine level bomber
	"Floatplane",		# single engine floatplane, any role
	"Flying Boat",		# 2+ engine, lands on belly rather than floats
	"Transport"			# 2+ engine
) var subtype: String


@export_group("Movement - Airborne")
@export var min_speed: float
@export var max_speed: float
@export var acceleration: float
@export var climb_rate: float
@export var turn_rate: float
@export var ceiling: float

@export_group("Movement - Taxi")
@export var taxi_speed: float
@export var takeoff_speed: float
@export var taxi_turn_rate: float
@export var taxi_acceleration: float
@export var taxi_deceleration: float
@export var taxi_terrains: Array[Global.Terrains]
