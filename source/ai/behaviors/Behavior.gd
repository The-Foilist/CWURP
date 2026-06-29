class_name Behavior
extends RefCounted


var actor: Actor

var queued_for_deleteion: bool = false


func _init(in_actor: Actor, _params: Dictionary):
	self.actor = in_actor


func process(_delta) -> void:
	if queued_for_deleteion:
		return


func end() -> void:
	actor.behavior = null
	queued_for_deleteion = true
	actor.next_order()
