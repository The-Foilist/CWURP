class_name Mover
extends UnitActor


var speed_max: float


func move(_delta: float) -> void:
	pass
	

func _physics_process(delta: float) -> void:
	if Global.session.game.pause:
		return
	super(delta)
	move(delta * Global.session.game.time_scale)
