extends Behavior


var waypoint: LocationMarker
var loc: Vector2
var speed: float
var radius: float
var distance: float


func _init(actor: ShipMover, target: LocationMarker, speed: float, radius: float) -> void:
	self.actor = actor
	self.waypoint = target
	self.loc = target.global_position
	self.speed = speed
	self.radius = radius


func _to_string() -> String:
	return "Heading to %s (%.d, %.d) at %.1f %s." % [
		waypoint.display_name,
		waypoint.global_position.x,
		waypoint.global_position.y,
		speed / Global.SPEED_CONVERSION[PlayerSettings.ship_speed_units],
		PlayerSettings.ship_speed_units
	]


func preprocess() -> void:
	actor.speed_target = speed
	
	if actor.owning_player == Global.local_controller.player:
		Global.session.message_handler.send(actor, Global.local_controller.player, 'ack', _to_string())


func process() -> void:
	if actor.unit.global_position.distance_to(waypoint.global_position) < radius:
		success()
		return
	
	speed = actor.speed_target
	
	var heading_target = Global.bearing_to(actor.unit.global_position, waypoint.global_position)
	var heading_diff = fposmod(heading_target - actor.heading + 180, 360) - 180
	actor.rudder.set_target(heading_diff / actor.rudder_smoothness)


func success() -> void:
	var message = "Arrived at location %s." % waypoint.display_name
	Global.session.message_handler.send(actor, Global.local_controller.player, 'ack', message)
	super()


func fail() -> void:
	actor.rudder.set_target(0)
	var message = "Move order canceled."
	Global.session.message_handler.send(actor, Global.local_controller.player, 'ack', message)
	super()


func _on_waypoint_removed() -> void:
	actor.remove_order(self)
