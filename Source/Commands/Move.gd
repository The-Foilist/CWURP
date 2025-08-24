extends TargetedCommand


var target: LocationMarker


func validate_confirm(kwargs: Dictionary):
	if kwargs['target'] is LocationMarker:
		target = kwargs['target']
		return null
	elif kwargs['target'] is Vector2:
		target = create_waypoint(kwargs['target'])
		return null
	else:
		return 'Error: must target location or object.'


func confirm_queue(kwargs: Dictionary) -> void:
	super(kwargs)
	var behavior = load("res://Source/Actors/Behaviors/Move.gd").new(actor, target, actor.speed_target, 100)
	target.removed.connect(behavior._on_waypoint_removed)
	actor.append_order(behavior)


func confirm(kwargs: Dictionary) -> void:
	super(kwargs)
	var behavior = load("res://Source/Actors/Behaviors/Move.gd").new(actor, target, actor.speed_target, 100)
	target.removed.connect(behavior._on_waypoint_removed)
	actor.replace_orders(behavior)
	Global.local_controller.targeting = null


func process(_delta: float) -> void:
	var coords = Global.local_controller.cam.get_global_mouse_position()
	target_text = '%s: %s -> (%.d, %.d)' % [actor.unit.display_name, target_text_base, coords.x, coords.y]


func create_waypoint(pos: Vector2) -> LocationMarker:
	var player = Global.local_controller.player
	var new_marker = load("res://Source/UI/World/LocationMarker.tscn").instantiate()
	new_marker.player = player
	new_marker.global_position = pos
	new_marker.display_name = 'Waypoint ' + str(Global.local_controller.player.marker_number)
	player.marker_number += 1
	player.markers.append(new_marker)
	Global.game.map_ui_layer.add_child(new_marker)
	return new_marker
