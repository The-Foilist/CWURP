class_name Mover
extends UnitActor


var speed_max: float

var speed: float
var heading: float

func move(_delta: float) -> void:
	pass
	

func _physics_process(delta: float) -> void:
	if Global.game.pause:
		return
	super(delta)
	move(delta * Global.game.time_scale)
