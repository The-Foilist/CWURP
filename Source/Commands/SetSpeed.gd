extends Command


func validate_start(kwargs: Dictionary):
	if kwargs['target'] is float:
		return null
	else:
		return 'Error: must supply a numeric value.'


func start(kwargs: Dictionary) -> void:
	super(kwargs)
	actor.set_speed(kwargs['target'])
	Global.local_controller.targeting = null
