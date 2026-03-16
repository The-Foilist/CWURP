class_name Unit
extends AnimatableBody2D


var display_name: String

@export var statblock: StatblockUnit
@export var world: World
@export var owning_player: Player
@export var starting_data: Dictionary

var height: float = 0
var speed: float = 0


signal died


func _ready() -> void:
	display_name = statblock.display_name
	if !starting_data:
		return
	if starting_data['height']:
		height = starting_data.height


func kill() -> void:
	emit_signal("died")
	get_parent().remove_child(self)
	queue_free()
