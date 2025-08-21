class_name Command
extends RefCounted


var actor: Actor


func _init(_data: CommandData, actor: Actor = null) -> void:
	self.actor = actor


func validate_start(_kwargs: Dictionary):
	return null


func start(kwargs: Dictionary):
	if validate_start(kwargs):
		return


func process(_delta) -> void:
	pass


func cancel() -> void:
	pass
