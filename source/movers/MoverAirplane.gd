class_name MoverAirplane
extends Mover

@export var taxi_mover: MoverTaxi

var stall_speed: float
var thrust_max: float
var drag_coef: float
var turn_rate: float

var power_setting: float
var air_speed: float
var velocity: Vector2
var pitch_angle: float
var stall: bool = false
var ground_speed: float
var track_heading: float
var runway: Unit

@export var target_speed: float
@export var target_heading: float
@export var target_altitude: float


func _ready() -> void:
	super()
	inspector = load("res://source/ui/game/inspectors/InspectorAirplane.tscn")
	thrust_max = unit.statblock.engine_thrust
	drag_coef = unit.statblock.drag_coef
	stall_speed = unit.statblock.stall_speed
	turn_rate = unit.statblock.turn_rate
	active = false


func land() -> void:
	taxi_mover.target_speed = 0
	taxi_mover.target_heading = track_heading
	taxi_mover.air_speed = air_speed
	taxi_mover.ground_speed = unit.speed
	switch_mover(taxi_mover)
	if runway:
		var pos = unit.global_position
		world.object_layer.remove_child(unit)
		unit.global_position = pos
		runway.add_child(unit)


func move(delta: float) -> void:
	pos_data = world.get_data_at_position(unit.global_position, unit.height)
	var vel_norm = velocity.normalized()
	
	var thrust_target = clamp(pos_data['air_density'] * drag_coef * target_speed**2, 0, thrust_max)
	var alt_diff = (target_altitude - unit.height)/(air_speed * delta)
	var pitch_target = asin(clamp(alt_diff, -thrust_target / (unit.mass * 9.8), 2 * thrust_target / (3 * unit.mass * 9.8)))
	var heading_diff = fposmod(target_heading - unit.global_rotation_degrees + 180, 360) - 180
	var out_rot = clamp(deg_to_rad(heading_diff), -turn_rate * delta, turn_rate * delta)
	
	power_setting = clamp((thrust_target + unit.mass * 9.8 * sin(pitch_target)) / thrust_max, 0, 1)
	velocity = velocity.rotated(clamp(pitch_target - pitch_angle, -turn_rate * delta, turn_rate * delta))
	
	# Engine pulls you forward, drag pushes you back
	var thrust = thrust_max * power_setting * vel_norm
	var drag = drag_coef * pos_data['air_density'] * velocity.length_squared() * -vel_norm
	
	# Weight pulls you down if stalled, otherwise adjusts your velocity based on pitch
	var weight: Vector2
	if velocity.length() < stall_speed * 1.225 / pos_data['air_density']:
		stall = true
		velocity += 9.8 * Vector2.UP
	else:
		stall = false
		weight = 9.8 * -vel_norm.y * vel_norm
	
	velocity += ((thrust + drag) / unit.mass + weight) * delta
	
	air_speed = velocity.length()
	pitch_angle = velocity.angle()
	
	unit.height += velocity.y * delta
	if unit.height < max(0, pos_data['height']):
		unit.kill()
		return
	
	var out_vel = velocity.x * -unit.global_transform.y + pos_data['wind']
	unit.speed = out_vel.length()
	track_heading = rad_to_deg(out_vel.angle()) + 90
	
	unit.rotate(out_rot)
	unit.translate(out_vel * delta)
