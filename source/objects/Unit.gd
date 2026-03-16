class_name Unit
extends AnimatableBody2D


var display_name: String

@export var statblock: StatblockUnit
@export var world: World
@export var owning_player: Player
@export var starting_data: Dictionary
@export var active_mover: Mover

var unit_type: Global.UnitTypes
var unit_subtype: String = ''
var unit_model: String = ''

var height: float = 0
var speed: float = 0


signal died


func _ready() -> void:
	
	unit_type = statblock.type
	unit_model = statblock.model
	if "subtype" in statblock:
		unit_subtype = statblock.subtype
	display_name = statblock.display_name
	if !starting_data:
		return
	if 'height' in starting_data:
		height = starting_data['height']


func kill() -> void:
	emit_signal("died")
	get_parent().remove_child(self)
	queue_free()
