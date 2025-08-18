class_name Hull
extends UnitComponent

@onready var mass: float = unit.statblock.displacement
@onready var draft: float = unit.statblock.draft
@onready var drag: float = unit.statblock.hull_drag
@onready var turn_radius: float = unit.statblock.turn_radius

var drag_mod: float = 1.0

func _init() -> void:
	collision_layer = 7
	collision_mask = 6
