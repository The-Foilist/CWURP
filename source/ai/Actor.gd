class_name Actor
extends Node


@export var unit: Unit
@export var comms: Comms


func parse_order(message: String) -> void:
	var split_msg = message.split(" ")
	if unit.active_mover is MoverTaxi:
		if split_msg[0] == 'takeoff':
			unit.active_mover.target_speed = INF
	elif unit.active_mover is MoverAirplane:
		match split_msg[0]:
			'speed':
				if split_msg[1] == 'max':
					unit.active_mover.target_speed = INF
				else:
					unit.active_mover.target_speed = float(split_msg[1]) * Global.SPEED_CONVERSION[PlayerSettings.aircraft_speed_units]
			'alt':
				unit.active_mover.target_altitude = float(split_msg[1]) * Global.DISTANCE_CONVERSION[PlayerSettings.altitude_units]
			'course':
				match split_msg[1]:
					'north', 'n':
						unit.active_mover.target_heading = 0
					'east', 'e':
						unit.active_mover.target_heading = 90
					'south', 's':
						unit.active_mover.target_heading = 180
					'west', 'w':
						unit.active_mover.target_heading = 270
					_:
						unit.active_mover.target_heading = float(split_msg[1])
