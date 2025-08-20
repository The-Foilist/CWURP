class_name Behavior
extends Resource


var actor: Actor


signal completed()
signal failed()


func validate():
	pass


func preprocess() -> void:
	if actor.owning_player == Global.session.local_controller.player:
		Global.session.message_handler.send(actor, Global.session.local_controller.player, 'ack', _to_string())


func process() -> void:
	pass


func success() -> void:
	emit_signal("completed")


func fail() -> void:
	emit_signal("completed")
