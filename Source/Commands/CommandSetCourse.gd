class_name CommandSetCourse
extends Command


var actor: Actor
var behavior: Behavior


func _init(actor: Actor, behavior: Behavior):
	self.actor = actor
	if actor.owning_player != Global.session.local_controller.player:
		Global.session.message_handler.send(null, Global.session.local_controller.player, 'error', 'Error: you can only issue orders to units under your control.')
		self.cancel()
		self.free()
		return
	self.behavior = behavior
	self.cursor = Input.CURSOR_CROSS
	self.target_text = "Select target..."


func validate(target):
	if target is Vector2:
		return target
	elif target is Unit:
		target = target.global_position
		return target
	return null


func confirm(target) -> void:
	target = validate(target)
	if !target:
		if cancel_on_fail:
			cancel()
		else:
			return
	
	if actor is Group:
		behavior.heading_target = Global.bearing_to(actor.center, target)
		var new_behavior = GroupSetCourse.new(actor, Global.bearing_to(actor.center, target), behavior.direction, behavior.radius)
		actor.switch_behavior(new_behavior)
	
	elif actor is Mover:
		behavior.heading_target = Global.bearing_to(actor.unit.global_position, target)
		actor.switch_behavior(behavior)
	
	super(target)
