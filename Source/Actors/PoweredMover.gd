class_name PoweredMover
extends Mover


var fuel_percent: float
var fuel_range: float
var fuel_endurance: float
var speed_target: float

# Given a speed, estimate how long until current fuel runs out
func estimate_endurance(speed: float, fuel: float) -> float:
	return 0


# Given a speed, estimate how far you can get with current fuel
func estimate_range(speed: float, fuel: float) -> float:
	return estimate_endurance(speed, fuel) * speed


# Given a speed and distance, estimate the fuel percentage required to reach
func estimate_fuel(speed: float, distance: float) -> float:
	return 0


# Given an elapsed time, estimate your location at current speed
func get_transform_after_time(seconds: float) -> Transform2D:
	return unit.transform.translated(-unit.transform.y * speed * seconds)


func set_speed(speed: float) -> void:
	speed_target = clamp(speed, 0, speed_max)
	var message = "Coming to %.1f %s." % [
		speed_target / Global.SPEED_CONVERSION[PlayerSettings.ship_speed_units],
		PlayerSettings.ship_speed_units
	]
	Global.session.message_handler.send(self, Global.local_controller.player, 'ack', message)
