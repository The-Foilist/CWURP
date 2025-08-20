class_name Command
extends Object


var controller: LocalController = Global.session.local_controller
var player: Player = Global.session.local_controller.player
var cursor: int 
var cancel_on_fail: bool = true
var target_text: String = 'null'


func validate(_target) :
	pass


# Called when the "confirm" button is pressed when targeting
func confirm(_target) -> void:
	controller.targeting = null


# Called when the "confirm" button is released when targeting
func release(_target) -> void:
	pass


# Called when the "cancel" button is pressed when targeting
func cancel() -> void:
	controller.targeting = null


func process(_delta: float) -> void:
	pass
