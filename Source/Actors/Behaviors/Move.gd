extends Behavior


var waypoints: Array[Waypoint2D] = []
var loop: bool = false
var speed: float
var distance: float


func _init(actor: ShipMover, target: Waypoint2D, speed: float, distance: float) -> void:
	self.actor = actor
	self.waypoints.append(target)
	self.speed = speed
	self.distance = distance
	waypoints[0].removed.connect(remove_waypoint)


func _to_string() -> String:
	return "Moving to location (%.d, %.d) at %.1f %s" % [
		waypoints[0].global_position.x,
		waypoints[0].global_position.y,
		speed / Global.SPEED_CONVERSION[PlayerSettings.ship_speed_units],
		PlayerSettings.ship_speed_units
	]


func clear_waypoints() -> void:
	for target in waypoints:
		target.remove()
	waypoints.clear()


func add_waypoint(waypoint: Waypoint2D) -> void:
	waypoint.prev_waypoint = waypoints[-1]
	waypoints.append(waypoint)
	waypoint.removed.connect(remove_waypoint)


func remove_waypoint(waypoint: Waypoint2D) -> void:
	var keep: Array[Waypoint2D] = []
	var prev = null
	for item in waypoints:
		if item != waypoint:
			keep.append(item)
			item.prev_waypoint = prev
			prev = item
	waypoints = keep
	
	if waypoints.size() > 0:
		Global.session.message_handler.send(actor, Global.local_controller.player, 'ack', _to_string())
		return
	
	fail()


func preprocess() -> void:
	if actor.owning_player == Global.local_controller.player:
		Global.session.message_handler.send(actor, Global.local_controller.player, 'ack', _to_string())


func process() -> void:
	if actor.unit.global_position.distance_to(waypoints[0].global_position) < distance:
		success()
		return

	var setting_target = actor.speed_to_setting(waypoints[0].speed)
	actor.powerplant.set_target(setting_target)
	
	var heading_target = Global.bearing_to(actor.unit.global_position, waypoints[0].global_position)
	var heading_diff = fposmod(heading_target - actor.heading + 180, 360) - 180
	actor.rudder.set_target(heading_diff / actor.rudder_smoothness)


func switch_out() -> void:
	clear_waypoints()
	actor.rudder.set_target(0)


func success() -> void:
	var message = "Arrived at location (%.d, %.d); " % [waypoints[0].global_position.x, waypoints[0].global_position.y]
	var last_waypoint = waypoints.pop_front()
	if loop:
		add_waypoint(last_waypoint)
	else:
		last_waypoint.remove()
	
	if waypoints.size() == 0:
		actor.rudder.set_target(0)
		message += "maintaining present course and speed."
		Global.session.message_handler.send(actor, Global.local_controller.player, 'ack', message)
		super()
		return
	
	message += "proceeding to location (%.d, %.d)." % [waypoints[0].global_position.x, waypoints[0].global_position.y]
	Global.session.message_handler.send(actor, Global.local_controller.player, 'ack', message)


func fail() -> void:
	clear_waypoints()
	actor.rudder.set_target(0)
	
	var message = "Move order canceled; maintaining present course and speed."
	Global.session.message_handler.send(actor, Global.local_controller.player, 'ack', message)
	super()
