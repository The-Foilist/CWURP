class_name PoweredMover
extends Mover


var fuel_range: float
var fuel_endurance: float


# Given a speed, estimate how long until current fuel runs out
func estimate_endurance(speed: float, fuel: float) -> float:
	return 0


# Given a speed, estimate how far you can get with current fuel
func estimate_range(speed: float, fuel: float) -> float:
	return estimate_endurance(speed, fuel) * speed


# Given an elapsed time, estimate your location at current speed
func get_transform_after_time(seconds: float) -> Transform2D:
	return unit.transform.translated(-unit.transform.y * speed * seconds)
