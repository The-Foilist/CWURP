class_name Order
extends Resource


enum Priority {
	OVERRIDE = 0,
	FIRST = 1,
	LAST = 2
}


@export var actor_types: Array[GDScript]
@export var behavior_script: GDScript
@export var params: Array[String]


func issue(actor: Actor, priority: int, param_dict: Dictionary) -> String:
	# Check that the given actor is allowed to receive this order
	# and that this order is in the given actor's list of allowed orders
	if not (self in actor.allowed_orders):
		return '%s cannot accept "%s" orders.' % [actor.get_script().get_global_name(), self.resource_name]
	var check = false
	for type in actor_types:
		if actor.get_script() == type:
			check = true
			continue
	if not check:
		return 'Order "%s" cannot be issued to a %s.' % [self.resource_name, actor.get_script().get_global_name()]
	
	actor.add_order(self, priority, param_dict)
	return 'ok'


func execute(actor: Actor, param_dict: Dictionary) -> String:
	actor.behavior = behavior_script.new(actor, param_dict)
	return 'ok'
