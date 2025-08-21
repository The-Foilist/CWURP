extends TargetedCommand


var ruler: Line2D
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
	ruler = preload("res://Source/UI/World/Ruler.tscn").instantiate()
	Global.session.game.map_ui_layer.add_child(ruler)
	ruler.clear_points()
	ruler.add_point(target)
	ruler.add_point(target)
	ruler.visible = true


func release(kwargs: Dictionary) -> void:
	super(kwargs)
	ruler.visible = false
	ruler.clear_points()
	Global.session.game.map_ui_layer.remove_child(ruler)
	ruler.queue_free()
	ruler = null


func cancel() -> void:
	if ruler:
		release({})
	super()


func process(_delta: float) -> void:
	if ruler:
		var mouse_pos = Global.session.local_controller.cam.get_global_mouse_position()
		ruler.set_point_position(1, mouse_pos)
