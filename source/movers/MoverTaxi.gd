class_name MoverTaxi
extends MoverAirplane

@export var airborne_mover: MoverFlying

var taxi_speed: float
var takeoff_speed: float
var accel_coef: float
var deceleration: float
var allowed_terrains: Array[int]

var brake: float = 0
var airspeed_vec: Vector2
var crosswind: float = 0


func _ready() -> void:
	super()
	heading_target = fposmod(unit.global_rotation_degrees, 360)
	turn_rate = unit.statblock.taxi_turn_rate
	taxi_speed = unit.statblock.taxi_speed
	takeoff_speed = unit.statblock.takeoff_speed
	accel_coef = unit.statblock.taxi_accel_coef
	deceleration = unit.statblock.taxi_brake_decel
	allowed_terrains = unit.statblock.taxi_terrains
	
	if unit.starting_data and 'airborne' in unit.starting_data and unit.starting_data['airborne']:
		active = false
	if unit.get_parent() is Runway:
		runway = unit.get_parent()
		unit.height = runway.height


func liftoff() -> void:
	airborne_mover.velocity.x = air_speed
	airborne_mover.velocity.y = 0
	airborne_mover.heading_target = unit.global_rotation_degrees
	unit.height += 0.1
	if runway:
		airborne_mover.runway = runway
		var pos = unit.global_position
		var rot = unit.global_rotation
		runway.remove_child(unit)
		unit.global_position = pos
		unit.global_rotation = rot
		unit.world.object_layer.add_child(unit)
		runway = null
	
	switch_mover(airborne_mover)


func set_brake(value: float) -> void:
	brake = clamp(value, 0, 1)


func process_session_time(delta: float) -> void:
	super(delta)
	if runway and runway in check_runways():
		unit.height = runway.height
	else:
		if pos_data['terrain'] not in allowed_terrains:
			unit.kill()
			return
		if abs(pos_data['height'] - unit.height) >= 1:
			unit.kill()
			return
	
	# Rotation
	var heading_diff = fposmod(heading_target - unit.global_rotation_degrees + 180, 360) - 180
	var out_rot = clamp(deg_to_rad(heading_diff), -turn_rate * delta, turn_rate * delta)
	
	# Translation
	ground_speed += engine.thrust * accel_coef / unit.mass * delta
	ground_speed -= min(ground_speed, brake * deceleration * delta)
	var out_vel = ground_speed * -unit.global_transform.y
	airspeed_vec = (out_vel - pos_data['wind'])
	if runway:
		airspeed_vec += runway.velocity
	air_speed = airspeed_vec.project(-unit.global_transform.y).length()
	crosswind = airspeed_vec.slide(-unit.global_transform.y).length()
	
	unit.rotate(out_rot)
	unit.global_translate(out_vel * delta)
	
	if air_speed > takeoff_speed * 1.225 / pos_data['air_density']:
		liftoff()
