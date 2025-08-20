class_name SetCourse
extends Behavior


var heading_target: float
var direction: String
var radius: float


func _init(actor: Actor, heading_target: float, direction: String, radius) -> void:
	self.actor = actor
	self.heading_target = heading_target
	self.direction = direction
	self.radius = radius


func _to_string() -> String:
	return "Coming %sto course %03d." % [direction, heading_target]


func validate():
	if actor.owning_player != Global.session.local_controller.player:
		return "You can only issue orders to units under your control."
	if not actor:
		return "Only ships can parse this order."
	if !(actor is ShipMover):
		return "Only ships can parse this order."
	return null


func process() -> void:
	var heading_diff = fposmod(heading_target - actor.heading + 180, 360) - 180
	if direction == "left ":
		heading_diff = fposmod(heading_target - actor.heading, 360) - 360
	elif direction == "right ":
		heading_diff = fposmod(heading_target - actor.heading, 360)
	
	var pos_clamp = min(actor.hull.turn_radius / radius, 1)
	actor.rudder.pos_target = clamp(heading_diff / actor.rudder_smoothness, -pos_clamp, pos_clamp)
