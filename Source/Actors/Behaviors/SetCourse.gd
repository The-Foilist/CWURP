extends Behavior


var heading_target: float
var direction: String
var radius: float


func _init(actor: Actor, heading_target: float, direction: String, radius) -> void:
	self.actor = actor as ShipMover
	self.heading_target = heading_target
	self.direction = direction
	self.radius = radius


func _to_string() -> String:
	return "Coming %sto course %03d." % [direction, heading_target]


func process() -> void:
	var heading_diff = fposmod(heading_target - actor.heading + 180, 360) - 180
	if abs(heading_diff) < 0.01:
		success()
	
	if direction == "left ":
		heading_diff = fposmod(heading_target - actor.heading, 360) - 360
	elif direction == "right ":
		heading_diff = fposmod(heading_target - actor.heading, 360)
	
	var pos_clamp = min(actor.hull.turn_radius / radius, 1)
	actor.rudder.set_target(clamp(heading_diff / actor.rudder_smoothness, -pos_clamp, pos_clamp))


func preprocess() -> void:
	if actor.owning_player == Global.local_controller.player:
		Global.session.message_handler.send(actor, Global.local_controller.player, 'ack', _to_string())
	print(heading_target)


func success() -> void:
	actor.rudder.set_target(0)
	var message = "Established on course %03d." % heading_target
	Global.session.message_handler.send(actor, Global.local_controller.player, 'ack', message)
	super()
