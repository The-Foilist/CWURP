class_name Runway
extends UnitComponentPhysical

@export var start_heading: float
@export var start_height: float
@export var touchdown_point: Node2D
@export var end_point: Node2D

var velocity: Vector2 = Vector2(0,0)
var height: float
var heading: float


func _init() -> void:
	collision_layer = 3
	collision_mask = 0


func _physics_process(_delta) -> void:
	height = start_height + unit.height
