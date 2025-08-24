class_name Behavior
extends RefCounted


var actor: Actor
var prev: Behavior
var next: Behavior

var time: float = 0


signal completed
signal failed
signal removed


func validate():
	pass


func preprocess() -> void:
	pass


func process() -> void:
	pass


func removed_from_queue() -> void:
	if next:
		next.prev = prev
	if prev:
		prev.next = next


func success() -> void:
	emit_signal("completed")
	actor.next_order()


func fail() -> void:
	emit_signal("failed")
	actor.next_order()
