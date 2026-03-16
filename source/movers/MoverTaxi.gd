class_name MoverTaxi
extends Mover

@export var airborne_mover: MoverAirplane

var takeoff_speed: float
var acceleration: float
var deceleration: float
var turn_rate: float
var allowed_terrains: Array[int]

var runway: Runway
var ground_speed: float = 0
var air_speed: float = 0
var crosswind: float = 0
@export var target_speed: float
@export var target_heading: float


func _ready() -> void:
	super()
	target_heading = fposmod(unit.global_rotation_degrees, 360)
	takeoff_speed = unit.statblock.takeoff_speed
	acceleration = unit.statblock.taxi_acceleration
	deceleration = unit.statblock.taxi_deceleration
	turn_rate = unit.statblock.taxi_turn_rate
	allowed_terrains = unit.statblock.taxi_terrains
	if unit.get_parent() is Runway:
		runway = unit.get_parent()
		unit.height = runway.height


func liftoff() -> void:
	airborne_mover.air_speed = air_speed
	airborne_mover.target_speed = INF
	airborne_mover.target_altitude = INF
	airborne_mover.velocity = ground_speed * -unit.global_transform.y
	switch_mover(airborne_mover)
	if runway:
		var pos = unit.global_position
		runway.remove_child(unit)
		unit.global_position = pos
		world.object_layer.add_child(unit)


func move(delta: float) -> void:
	if runway:
		unit.height = runway.height
		pass
	else:
		if pos_data['terrain'] not in allowed_terrains:
			unit.kill()
			return
		if abs(pos_data['height'] - unit.height) >= 1:
			unit.kill()
			return
	
	# Rotation
	var heading_diff = fposmod(target_heading - unit.global_rotation_degrees + 180, 360) - 180
	var out_rot = clamp(heading_diff, -turn_rate * delta, turn_rate * delta)
	
	# Translation
	ground_speed += clamp(target_speed - ground_speed, -deceleration * delta, acceleration * delta)
	var out_vel = ground_speed * -unit.global_transform.y
	var out_vel_norm = out_vel.normalized()
	var airspeed_vec = (out_vel - pos_data['wind'])
	if runway:
		airspeed_vec += runway.velocity
	air_speed = airspeed_vec.project(out_vel_norm).length()
	crosswind = airspeed_vec.slide(out_vel_norm).length()
	
	unit.rotate(deg_to_rad(out_rot))
	unit.translate(out_vel * delta)
	
	if air_speed >= takeoff_speed:
		liftoff()
