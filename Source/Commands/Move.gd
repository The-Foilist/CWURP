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


func confirm_queue(kwargs: Dictionary) -> void:
	super(kwargs)
	var new_marker = create_waypoint(target)
	if actor.behavior:
		if "waypoints" in actor.behavior:
			actor.behavior.add_waypoint(new_marker)
			Global.game.map_ui_layer.add_child(new_marker)
			return
	
	var behavior = load("res://Source/Actors/Behaviors/Move.gd").new(actor, new_marker, actor.speed, 100)
	actor.switch_behavior(behavior)


func confirm(kwargs: Dictionary) -> void:
	super(kwargs)
	if actor.behavior:
		if "waypoints" in actor.behavior:
			actor.behavior.clear_waypoints()
	var new_marker = create_waypoint(target)
	var behavior = load("res://Source/Actors/Behaviors/Move.gd").new(actor, new_marker, actor.speed, 100)
	actor.switch_behavior(behavior)
	Global.local_controller.targeting = null


func process(_delta: float) -> void:
	target = Global.local_controller.cam.get_global_mouse_position()
	target_text = '%s: %s -> (%.d, %.d)' % [actor.unit.display_name, target_text_base, target.x, target.y]


func create_waypoint(pos: Vector2) -> Waypoint2D:
	var player = Global.local_controller.player
	var new_marker = load("res://Source/UI/World/Waypoint2D.tscn").instantiate()
	new_marker.player = player
	new_marker.global_position = pos
	new_marker.name = 'Waypoint ' + str(Global.local_controller.player.marker_number)
	new_marker.mover = actor
	new_marker.speed = actor.speed
	player.marker_number += 1
	player.markers.append(new_marker)
	Global.game.map_ui_layer.add_child(new_marker)
	return new_marker
