class_name Mover
extends Node

@export var unit: Unit

var world: World
var inspector: PackedScene

var active: bool = true
var pos_data: Dictionary


func _ready():
	world = unit.world
	active = unit.active_mover == self


func switch_mover(new_mover: Mover):
	new_mover.pos_data = world.get_data_at_position(unit.global_position)
	active = false
	new_mover.active = true
	unit.active_mover = new_mover


func move(_delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if world.pause:
		return
	if !active:
		return
	pos_data = world.get_data_at_position(unit.global_position)
	move(delta * world.time_scale)
