extends Behavior


var target: Vector2
var distance: float


func _init(actor: Actor, target: Vector2, distance: float) -> void:
	self.actor = actor as ShipMover
	self.target = target
	self.distance = distance


func _to_string() -> String:
	return "Approaching location (%.d, %.d)" % [target.x, target.y]


func process() -> void:
	if actor.unit.global_position.distance_to(target) < distance:
		success()
	var heading_target = Global.bearing_to(actor.unit.global_position, target)
	var heading_diff = fposmod(heading_target - actor.heading + 180, 360) - 180
	actor.rudder.set_target(heading_diff / actor.rudder_smoothness)


func preprocess() -> void:
	if actor.owning_player == Global.session.local_controller.player:
		Global.session.message_handler.send(actor, Global.session.local_controller.player, 'ack', _to_string())

func success() -> void:
	var message = "Arrived at location (%.d, %.d)" % [target.x, target.y]
	Global.session.message_handler.send(actor, Global.session.local_controller.player, 'ack', message)
	super()
