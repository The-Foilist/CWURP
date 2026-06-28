class_name Actor
extends UnitComponentEthereal


@export var comms: Comms

var inspector: PackedScene
var orders: Array[DataOrder]
var behavior: Behavior


func process_session_time(delta: float) -> void:
	if behavior:
		behavior.process(delta)
