class_name UnitActor
extends Actor


@export var unit: Unit


func _ready():
	owning_player = unit.owning_player
