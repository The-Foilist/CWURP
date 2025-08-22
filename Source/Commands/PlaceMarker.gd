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
	var player = Global.local_controller.player
	var new_marker = player.create_marker(target)
	Global.session.message_handler.send(null, player, 'map', 'Placed %s at (%d,%d).' % [Global.session.message_handler.wrap_name(new_marker), target.x, target.y])
	Global.local_controller.targeting = null
