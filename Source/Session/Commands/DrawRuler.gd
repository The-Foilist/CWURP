class_name CommandDrawRuler
extends Command


var ruler = preload("res://Source/UI/World/Ruler.tscn").instantiate()


func _init(player: Player):
	super(player)
	self.cursor = Input.CURSOR_CROSS
	player.game.map_ui_layer.add_child(ruler)
	self.ruler.width = 2
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
	ruler.clear_points()
	ruler.add_point(target)
	ruler.add_point(target)
	ruler.visible = true


func release(target) -> void:
	ruler.visible = false
	ruler.clear_points()


func process(delta: float) -> void:
	if !ruler.visible:
		return
	ruler.set_point_position(1, controller.cam.get_global_mouse_position())
