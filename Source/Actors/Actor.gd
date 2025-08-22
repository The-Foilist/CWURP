class_name Actor
extends Node


@export var owning_player: Player


var behavior: Behavior
var inspector: String


func switch_behavior(new_behavior: Behavior = null) -> void:
	if !new_behavior:
		behavior = null
		return
	if new_behavior.validate():
		return
	behavior = new_behavior
	behavior.preprocess()


func _physics_process(_delta: float) -> void:
	if Global.game.pause:
		return
	if behavior:
		behavior.process()
