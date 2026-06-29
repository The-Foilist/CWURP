class_name Mover
extends UnitComponentEthereal


var pos_data: Dictionary


func _ready() -> void:
	active = unit.active_mover == self


func switch_mover(new_mover: Mover) -> void:
	new_mover.pos_data = unit.world.get_data_at_position(unit.global_position, unit.height)
	active = false
	new_mover.active = true
	unit.active_mover = new_mover


func process_session_time(_delta: float) -> void:
	pos_data = unit.world.get_data_at_position(unit.global_position, unit.height)
