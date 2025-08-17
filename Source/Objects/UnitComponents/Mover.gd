class_name Mover
extends Node


var inspector: String


func move(delta: float) -> void:
	pass
	

func _physics_process(delta: float) -> void:
	if Global.session.game.pause:
		return
	move(delta * Global.session.game.time_scale)
