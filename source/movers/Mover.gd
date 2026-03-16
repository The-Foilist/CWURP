class_name Mover
extends Node

@export var unit: Unit
@export var active: bool = true

var world: World
var inspector: PackedScene

var pos_data: Dictionary

func _ready():
	world = unit.world


func move(_delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if world.pause:
		return
	if !active:
		return
	pos_data = world.get_data_at_position(unit.global_position)
	move(delta * world.time_scale)
