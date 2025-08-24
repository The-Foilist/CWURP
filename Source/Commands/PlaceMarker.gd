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
	var new_marker = load("res://Source/UI/World/LocationMarker.tscn").instantiate()
	new_marker.player = player
	new_marker.global_position = kwargs['target']
	new_marker.display_name = 'Marker ' + str(player.marker_number)
	player.marker_number += 1
	player.markers.append(new_marker)
	Global.game.map_ui_layer.add_child(new_marker)
	Global.session.message_handler.send(null, player, 'map', 'Placed %s at (%d,%d).' % [Global.session.message_handler.wrap_name(new_marker), kwargs['target'].x, kwargs['target'].y])
	Global.local_controller.targeting = null
