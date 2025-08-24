class_name MessageHandler
extends Node


const MESSAGE_TYPES = ['ack', 'order']


@onready var session := get_parent()


signal message(content: String)
signal filter(type: int, param: String, on: bool)


func wrap_name(object: Node) -> String:
	if (object is UnitActor) or (object is UnitComponent):
		object = object.unit
	var out_string: String = '[b][url=%s]%s[/url][/b]' % [object.get_instance_id(), object.display_name]
	if object is Player:
		out_string = '[color=#%s]%s[/color]' % [object.color.to_html(false), out_string]
	if (object is Unit) or (object is Group):
		out_string = '[color=#%s]%s[/color]' % [object.owning_player.color.to_html(false), out_string]
	return out_string


func send(sender: Node, receiver: Node, type: String, content: String) -> void:
	if content == '':
		return
		
	var display_text = content
	
	# Add sender and receiver
	if !sender:
		pass
	elif !receiver:
		display_text = '[sender]' + wrap_name(sender) + '[/sender]: ' + display_text
	else:
		display_text = '[receiver]' + wrap_name(receiver) + '[/receiver] from [sender]' + wrap_name(sender) + '[/sender]: ' + display_text
	# Add timestamp
	display_text = '[timestamp][%s][/timestamp] ' % session.game.current_time + display_text
	# Add message type
	display_text = '[type s=%s][/type]' % type + display_text
	
	if session.local_controller.player == receiver || session.local_controller.player:
		emit_signal('message', display_text)
	session.local_controller.player.message_log.append(display_text)
	
	if type == 'order' and receiver is Unit:
		receiver.parse_order(sender, content)
