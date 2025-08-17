class_name Rudder
extends UnitComponent

@onready var shift_rate: float = unit.statblock.rudder_shift_rate
@onready var drag: float = unit.statblock.rudder_drag

var pos: float
var pos_target: float

var shift_mod: float = 1


func set_target(val: float) -> void:
	pos_target = clamp(val, -1, 1)


func update(delta: float) -> void:
	super(delta)
	var amt = delta * shift_rate * shift_mod
	pos += clamp(pos_target - pos, -amt, amt)
	pos = clamp(pos, -1, 1)
