class_name Runway
extends UnitComponent

@export var start_heading: float
@export var start_height: float
var velocity: Vector2 = Vector2(0,0)
var height: float
var heading: float

func _init() -> void:
	collision_layer = 3
	collision_mask = 0


func _physics_process(_delta) -> void:
	height = start_height + unit.height
	heading = fposmod(start_heading + unit.global_rotation_degrees, 360)
