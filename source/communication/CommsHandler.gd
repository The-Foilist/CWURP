class_name CommsHandler
extends Node


enum ComMedium {
	Visual = 0,
	Wired = 1,
	Radio = 2
}


signal message_logged(content: String)


func _ready() -> void:
	message_logged.connect(Global.local_controller.ui_message_log._add_message)


func wrap_name(object: Node) -> String:
	if object is UnitComponent:
		object = object.unit
	var out_string: String = '[b][url=%s]%s[/url][/b]' % [object.get_instance_id(), object.display_name]
	if object is Player:
		out_string = '[color=#%s]%s[/color]' % [object.color.to_html(false), out_string]
	if (object is Unit):
		out_string = '[color=#%s]%s[/color]' % [object.owning_player.color.to_html(false), out_string]
	return out_string


func transmit(message: Message):
	if message.content == '':
		return
	
	# Format the message for logging
	var front_text = '[sender]%s[/sender]: ' % wrap_name(message.sender.unit)
	
	# Add sender and/or recipient, if present
	if message.recipient:
		front_text = '[receiver]%s[/receiver] from ' % wrap_name(message.recipient.unit) + front_text
	
	# Add timestamp
	front_text = '[timestamp][%s][/timestamp] ' % Global.world.time_str + front_text
	
	var display_text = front_text + message.content
	
	# Log messages with owning players of sender and receiver
	var logging_players: Array[Player] = []
	logging_players.append(message.sender.unit.owning_player)
	
	if message.recipient:
		message.recipient.receive(message)
		
		# If the sender and recipient are owned by the same player, don't log the message twice
		if logging_players[0] != message.recipient.unit.owning_player:
			logging_players.append(message.recipient.unit.owning_player)
	
	for player in logging_players:
		player.message_log.append(display_text)
		if player == Global.local_controller.player:
			emit_signal('message_logged', display_text)
