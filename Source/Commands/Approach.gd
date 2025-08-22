extends TargetedCommand


var target: Vector2


func validate_confirm(kwargs: Dictionary):
	if kwargs['target'] is Vector2:
		target = kwargs['target']
		return null
	elif kwargs['target'] is Node2D:
		target = kwargs['target'].global_position
		return null
	else:
		return 'Error: must target location or object.'


func confirm(kwargs: Dictionary) -> void:
	super(kwargs)
	var behavior = load("res://Source/Actors/Behaviors/Approach.gd").new(actor, target, 100)
	actor.switch_behavior(behavior)
	Global.local_controller.targeting = null


func process(_delta: float) -> void:
	target = Global.local_controller.cam.get_global_mouse_position()
	target_text = '%s: %s -> (%.d, %.d)' % [actor.unit.display_name, target_text_base, target.x, target.y]
