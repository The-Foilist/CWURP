class_name CommandPlaceMarker
extends Command


func _init(player: Player):
	super(player)
	self.cursor = Input.CURSOR_CROSS
	self.target_text = "Click to place a marker on the map..."


func validate(target):
	if target is Vector2:
		return target
	elif target is Unit:
		target = target.global_position
		return target
	return


func confirm(target) -> void:
	target = validate(target)
	if !target:
		if cancel_on_fail:
			cancel()
		else:
			return
	var new_marker = player.create_marker(target)
	Global.session.message_handler.send(null, player, 'map', 'Placed %s at (%d,%d).' % [Global.session.message_handler.wrap_name(new_marker), target.x, target.y])
	super(target)
