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
		return "Only groups of ships can parse this order."
	if !(actor is Group):
		return "Only groups of ships can parse this order."
	return null


func preprocess() -> void:
	for unit in actor.get_all_units(actor):
		var new_behavior = load("res://Source/Actors/Behaviors/SetCourse.gd").new(unit.mover, self.heading_target, self.direction, self.radius)
		unit.mover.switch_behavior(new_behavior)
