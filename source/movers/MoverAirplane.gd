class_name MoverAirplane
extends Mover

@export var taxi_mover: MoverTaxi

var stall_speed: float
var airspeed_max: float
var acceleration: float
var climb_rate: float
var ceiling: float
var turn_rate: float

var air_speed: float
var velocity: Vector2
var pitch_angle: float
var runway: Unit

@export var target_speed: float
@export var target_heading: float
@export var target_pitch: float


func _ready() -> void:
	super()
	inspector = load("res://source/ui/game/inspectors/InspectorAirplane.tscn")
	stall_speed = unit.statblock.min_speed
	airspeed_max = unit.statblock.max_speed
	acceleration = unit.statblock.acceleration
	climb_rate = unit.statblock.climb_rate
	ceiling = unit.statblock.ceiling
	turn_rate = unit.statblock.turn_rate
	active = false
	if unit.starting_data:
		if unit.starting_data['movement_type']:
			if unit.starting_data['movement_type'] == Global.MovementTypes.Air:
				active = true


func land() -> void:
	taxi_mover.target_speed = 0
	taxi_mover.target_heading = Global.vec_to_br(velocity).x
	taxi_mover.air_speed = air_speed
	taxi_mover.ground_speed = unit.speed
	switch_mover(taxi_mover)
	if runway:
		var pos = unit.global_position
		world.object_layer.remove_child(unit)
		unit.global_position = pos
		runway.add_child(unit)


func move(delta: float) -> void:
	# If you go too slow, you start to fall
	if air_speed < stall_speed:
		if unit.speed == 0:
			pitch_angle = -90
		else:
			pitch_angle -= rad_to_deg(atan(World.GRAVITY * delta / unit.speed))
	else:
		pitch_angle += clamp(target_pitch - pitch_angle, -turn_rate * delta, turn_rate * delta)
	
	# Gravity slows you down when you climb and speeds you up when you dive
	var grav = World.GRAVITY * sin(deg_to_rad(pitch_angle))
	air_speed += clamp(target_speed - air_speed, -(acceleration + grav) * delta, (acceleration - grav) * delta)
	air_speed = clamp(air_speed, 0, airspeed_max)
	
	unit.height += air_speed * sin(deg_to_rad(pitch_angle)) * delta
	
	if unit.height < max(pos_data['height'], 0):
		unit.kill()
		return
	
	var heading_diff = fposmod(target_heading - unit.global_rotation_degrees + 180, 360) - 180
	var out_rot = clamp(heading_diff, -turn_rate * delta, turn_rate * delta)
	
	velocity = air_speed * cos(deg_to_rad(pitch_angle)) * -unit.global_transform.y + pos_data['wind']
	unit.speed = velocity.length()
	
	unit.rotate(deg_to_rad(out_rot))
	unit.translate(velocity * delta)
