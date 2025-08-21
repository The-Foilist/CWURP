extends TargetedCommand


var target: float


func validate_confirm(kwargs: Dictionary):
	if kwargs['target'] is Vector2:
		target = Global.bearing_to(actor.center, kwargs['target'])
		return null
	elif kwargs['target'] is Node2D:
		target = Global.bearing_to(actor.center, kwargs['target'].global_position)
		return null
	elif kwargs['target'] is float:
		if kwargs['target'] >= 0 and kwargs['target'] < 360:
			target = kwargs['target']
			return null
	else:
		return 'Error: must target location or object, or supply a value in degrees.'


func confirm(kwargs: Dictionary) -> void:
	super(kwargs)
	var behavior = load("res://Source/Actors/Behaviors/SetCourseGroup.gd").new(actor, target, '', 1)
	actor.switch_behavior(behavior)
	print(actor)
	if actor.owning_player == Global.session.local_controller.player:
		Global.session.message_handler.send(actor, Global.session.local_controller.player, 'ack', behavior._to_string())
	Global.session.local_controller.targeting = null


func process(_delta: float) -> void:
	target = Global.bearing_to(actor.center, Global.session.local_controller.cam.get_global_mouse_position())
	target_text = actor.display_name + ': ' + target_text_base + ' -> ' + str(target)
