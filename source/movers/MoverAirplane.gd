class_name MoverAirplane
extends Mover

@export var engine: AircraftEngine

var turn_rate: float

var runway: Runway
var ground_speed: float
var air_speed: float

var heading_target: float


func _ready() -> void:
	super()


func check_runways() -> Array[Runway]:
	var new_params: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	new_params.collision_mask = 2
	new_params.exclude = [unit.get_rid()]
	new_params.position = unit.global_position
	var result = unit.get_world_2d().direct_space_state.intersect_point(new_params)
	var out_array: Array[Runway]
	if result:
		for dict in result:
			if dict.collider is Runway:
				out_array.append(dict.collider)
	return out_array
