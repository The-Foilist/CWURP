class_name Inspector
extends VBoxContainer


var linked_object: Node


func _process(_delta) -> void:
	if !linked_object:
		get_parent().remove_child(self)
		queue_free()
		return
