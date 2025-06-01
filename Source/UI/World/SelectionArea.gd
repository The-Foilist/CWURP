class_name SelectionArea
extends Area2D


@onready var connected_object: Node2D = get_parent()


func _on_input_event(viewport, event, shape_idx):
	if Global.session.local_controller.targeting:
		pass
	if event.is_action_pressed('select'):
		Global.session.local_controller.player.select(connected_object)
