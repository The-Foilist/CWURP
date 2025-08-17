class_name UnitComponent
extends StaticBody2D


@export var unit: Unit
var disabled: bool = false


func update(_delta: float) -> void:
	if disabled:
		return


func _physics_process(delta: float) -> void:
	if Global.session.game.pause:
		return
	update(delta * Global.session.game.time_scale)
