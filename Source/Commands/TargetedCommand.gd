class_name TargetedCommand
extends Command


var cursor: int
var target_text_base: String
var target_text: String


func _init(data: TargetedCommandData, actor: Actor = null) -> void:
	self.actor = actor
	self.cursor = data.cursor
	self.target_text_base = data.target_text
	self.target_text = self.target_text_base


func validate_confirm(_kwargs: Dictionary):
	return null


func confirm(kwargs: Dictionary):
	if validate_confirm(kwargs):
		return


func validate_release(_kwargs: Dictionary):
	return null


func release(kwargs: Dictionary):
	if validate_release(kwargs):
		return


func cancel() -> void:
	Global.local_controller.targeting = null
