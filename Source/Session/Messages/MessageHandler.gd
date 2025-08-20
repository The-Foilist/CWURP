class_name MessageHandler
extends Node


const MESSAGE_TYPES = ['welcome', 'chat', 'select', 'map']


@onready var session := get_parent()


signal message(content: String)
signal filter(type: int, param: String, on: bool)

func wrap_name(object: Node) -> String:
	var out_string: String = '[b][url=%s]%s[/url][/b]' % [object.get_instance_id(), object.display_name]
	if object is Player:
		out_string = '[color=#%s]%s[/color]' % [object.color.to_html(false), out_string]
	if (object is Unit) or (object is Group):
		out_string = '[color=#%s]%s[/color]' % [object.owning_player.color.to_html(false), out_string]
	return out_string


func send(sender: Node, receiver: Node, type: String, content: String) -> void:
	# Add sender
	if (sender is Player) or (sender is Unit):
		content = '[sender]' + wrap_name(sender) + '[/sender]: ' + content
	elif sender is UnitActor:
		content = '[sender]' + wrap_name(sender.unit) + '[/sender]: ' + content
	# Add timestamp
	content = '[timestamp][%s][/timestamp] ' % session.game.current_time + content
	# Add message type
	content = '[type s=%s][/type]' % type + content
	
	if session.local_controller.player == receiver:
		emit_signal('message', content)
	receiver.message_log.append(content)


func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text == '':
		return
	for player in session.players:
		send(session.local_controller.player, player, 'chat', new_text)
