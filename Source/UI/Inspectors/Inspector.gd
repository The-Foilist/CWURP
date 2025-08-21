class_name Inspector
extends VBoxContainer


var linked_actor: Actor


func _process(_delta) -> void:
	if !linked_actor:
		get_parent().remove_child(self)
		queue_free()
		return
