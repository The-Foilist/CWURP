class_name Actor
extends Node


@export var unit: Unit
@export var comms: Comms


func parse_order(message: String) -> void:
	var split_msg = message.split(" ")
	if unit.active_mover is MoverTaxi:
		if split_msg[0] == 'takeoff':
			unit.active_mover.target_speed = INF
	if unit.active_mover is MoverAirplane:
		match split_msg[0]:
			"pitch":
				unit.active_mover.target_pitch = float(split_msg[1])
			"course":
				unit.active_mover.target_heading = float(split_msg[1])
			"speed":
				unit.active_mover.target_speed = float(split_msg[1])
