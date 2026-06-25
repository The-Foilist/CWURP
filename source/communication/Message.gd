class_name Message
extends RefCounted


var handler: CommsHandler
var sender: Comms
var recipient: Comms
var content: String


func _init(s, r = null, c = '') -> void:
	handler = Global.scenario.comms_handler
	sender = s
	recipient = r
	content = c


func _to_string() -> String:
	var out_str = '[%s]: %s' % [sender.unit.get_instance_id(), content]
	if recipient:
		out_str = '[%s] from ' % recipient.unit.get_instance_id() + out_str
	return '%s ' % Global.world.time_str + out_str
