class_name DataOrder
extends Resource


@export var actor_types: Array[GDScript]
@export var behavior_script: GDScript
@export var params: Array[String]


func execute(actor: Actor, param_dict: Dictionary) -> String:
	if not (self in actor.orders):
		return '%s cannot accept "%s" orders.' % [actor.get_script().get_global_name(), self.resource_name]
	
	var check = false
	for type in actor_types:
		if actor.get_script() == type:
			check = true
			continue
	if not check:
		return 'Order "%s" cannot be issued to a %s.' % [self.resource_name, actor.get_script().get_global_name()]
	
	actor.behavior = behavior_script.new(actor, param_dict)
	return 'ok'
