class_name MoverFlying
extends MoverAirplane

@export var taxi_mover: MoverTaxi

var landing_speed: float
var stall_speed: float
var drag_coef: float

var flaps: bool = false
var velocity: Vector2
var pitch_angle: float
var stall: bool = false
var track_heading: float

var pitch_target: float


func _ready() -> void:
	super()
	turn_rate = unit.statblock.turn_rate
	drag_coef = unit.statblock.drag_coef
	stall_speed = unit.statblock.stall_speed
	landing_speed = unit.statblock.landing_speed
	if !unit.starting_data or not 'airborne' in unit.starting_data:
		active = false
	elif unit.starting_data['airborne'] == true:
		active = true
	else:
		active = false


func set_pitch_target(val: float) -> void:
	pitch_target = clamp(val, -PI/2, PI/2)


func set_heading_target(val: float) -> void:
	heading_target = clamp(val, 0, 360)


func land() -> void:
	taxi_mover.heading_target = track_heading
	taxi_mover.air_speed = air_speed
	taxi_mover.ground_speed = ground_speed
	if runway:
		taxi_mover.runway = runway
		var pos = unit.global_position
		var rot = unit.global_rotation
		unit.world.object_layer.remove_child(unit)
		runway.add_child(unit)
		unit.global_position = pos
		unit.global_rotation = rot
		unit.height = runway.height
	
	switch_mover(taxi_mover)


func process_session_time(delta: float) -> void:
	super(delta)
	var vel_norm = velocity.normalized()
	
	# Engine pulls you forward, drag pushes you back
	var thrust = engine.thrust * vel_norm
	var drag = drag_coef * pos_data['air_density'] * velocity.length_squared() * -vel_norm
	
	# Weight pulls you down if stalled, otherwise adjusts your velocity based on pitch
	var weight: Vector2
	if velocity.length() < stall_speed * 1.225 / pos_data['air_density']:
		stall = true
		velocity += 9.8 * Vector2(0,-1)
	else:
		stall = false
		if flaps:
			weight = 9.8 * -(0.05233595624 + vel_norm.y) * vel_norm
		else:
			weight = 9.8 * -vel_norm.y * vel_norm
	
	velocity = velocity.rotated(clamp(pitch_target - pitch_angle, -turn_rate * delta, turn_rate * delta))
	velocity += ((thrust + drag) / unit.mass + weight) * delta
	
	pitch_angle = velocity.angle()
	air_speed = velocity.length()
	
	unit.height += velocity.y * delta
	
	var height_agl = unit.height - pos_data['height']
	
	if height_agl <= 20 and velocity.y <= 0:
		if runway in check_runways() and air_speed < taxi_mover.takeoff_speed:
			if unit.height - runway.height <= 0:
				land()
		elif height_agl <= 0:
			unit.kill()
			return
	
	var heading_diff = fposmod(heading_target - unit.global_rotation_degrees + 180, 360) - 180
	var out_rot = clamp(deg_to_rad(heading_diff), -turn_rate * delta, turn_rate * delta)
	var out_vel = velocity.x * -unit.global_transform.y + pos_data['wind']
	ground_speed = out_vel.length()
	unit.speed = ground_speed
	track_heading = rad_to_deg(out_vel.angle()) + 90
	
	unit.rotate(out_rot)
	unit.translate(out_vel * delta)
