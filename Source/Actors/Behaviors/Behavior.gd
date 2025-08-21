class_name Behavior
extends Resource


var actor: Actor


signal completed()
signal failed()


func validate():
	pass


func preprocess() -> void:
	pass


func process() -> void:
	pass


func success() -> void:
	emit_signal("completed")


func fail() -> void:
	emit_signal("completed")
