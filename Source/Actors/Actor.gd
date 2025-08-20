class_name Actor
extends Node


@export var owning_player: Player


var behavior: Behavior
var inspector: String


func switch_behavior(new_behavior: Behavior) -> void:
	if new_behavior.validate():
		return
	behavior = new_behavior
	behavior.preprocess()


func _physics_process(delta: float) -> void:
	if Global.session.game.pause:
		return
	if behavior:
		behavior.process()
