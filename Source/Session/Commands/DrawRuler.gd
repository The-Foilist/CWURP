class_name CommandDrawRuler
extends Command


var ruler


func _init(player: Player):
	super(player)
	self.cursor = Input.CURSOR_CROSS
	self.target_text = "Click and drag to show distance and bearing..."


func validate(target):
	if target is Vector2:
		return target
	elif target is Unit:
		target = target.global_position
		return target
	return null


func confirm(target) -> void:
	target = validate(target)
	if !target:
		if cancel_on_fail:
			cancel()
		else:
			return
	ruler = preload("res://Source/UI/World/Ruler.tscn").instantiate()
	ruler.width = 2
	player.game.map_ui_layer.add_child(ruler)
	ruler.clear_points()
	ruler.add_point(target)
	ruler.add_point(target)
	ruler.visible = true


func release(_target) -> void:
	ruler.visible = false
	ruler.clear_points()
	player.game.map_ui_layer.remove_child(ruler)
	ruler.queue_free()
	ruler = null


func process(_delta: float) -> void:
	if ruler:
		ruler.set_point_position(1, controller.cam.get_global_mouse_position())
