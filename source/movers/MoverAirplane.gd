class_name MoverAirplane
extends Mover

@export var taxi_mover: MoverTaxi

var airspeed_min: float
var airspeed_max: float
var acceleration: float
var climb_rate: float
var ceiling: float
var turn_rate: float

var air_speed: float
var velocity: Vector2
var runway: Unit

@export var target_speed: float
@export var target_heading: float
@export var target_altitude: float


func _ready() -> void:
	super()
	inspector = load("res://source/ui/game/inspectors/InspectorAirplane.tscn")
	movement_type = Global.MovementTypes.Air
	airspeed_min = unit.statblock.min_speed
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
	unit.height += clamp(target_altitude - unit.height, -climb_rate * delta, climb_rate * delta)
	unit.height = min(unit.height, ceiling)
	if unit.height < max(pos_data['height'], 0):
		unit.kill()
		return
	
	var heading_diff = fposmod(target_heading - unit.global_rotation_degrees + 180, 360) - 180
	var out_rot = clamp(heading_diff, -turn_rate * delta, turn_rate * delta)
	
	air_speed += clamp(target_speed - air_speed, -acceleration * delta, acceleration * delta)
	air_speed = clamp(air_speed, airspeed_min, airspeed_max)
	
	velocity = air_speed * -unit.global_transform.y + pos_data['wind']
	unit.speed = velocity.length()
	
	unit.rotate(deg_to_rad(out_rot))
	unit.translate(velocity * delta)
