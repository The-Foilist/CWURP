class_name Command
extends Object


var controller: LocalController
var player: Player
var cursor: int
var cancel_on_fail: bool = true
var target_text: String = 'null'


func _init(player: Player):
	self.controller = Global.session.local_controller
	self.player = player


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
