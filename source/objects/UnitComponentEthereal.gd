class_name UnitComponentEthereal
extends Node


@export var unit: Unit

var active: bool = true

func process_session_time(_delta: float) -> void:
	pass


func _physics_process(delta):
	if unit.world.pause:
		return
	if !active:
		return
	process_session_time(delta * unit.world.time_scale)
	
