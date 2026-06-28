class_name CommsHandler
extends Node


signal message_logged(content: String)


func _ready() -> void:
	message_logged.connect(Global.local_controller.ui_message_log._add_message)


func parse_objects(text: String) -> String:
	var regex = RegEx.create_from_string('\\[(.*?)\\]')
	for result in regex.search_all(text):
		var obj_name = result.get_string().lstrip('[').rstrip(']')
		var obj = Global.scenario.get_object_by_name(obj_name)
		if obj:
			text = text.replace(result.get_string(), '[%d]' % obj.get_instance_id())
	return text


func direct_message_player(player: Player, message: String):
	message = Global.world.time_str + ' ' + message
	player.message_log.append(message)
	if Global.local_controller.player == player:
		Global.local_controller.ui_message_log._add_message(message)


func transmit(message: Message):
	if message.content == '':
		return
	
	message.content = parse_objects(message.content)
	
	# Log messages with owning players of sender and receiver
	var logging_players: Array[Player] = []
	logging_players.append(message.sender.unit.owning_player)
	
	if message.recipient:
		# If the sender and recipient are owned by the same player, don't log the message twice
		if logging_players[0] != message.recipient.unit.owning_player:
			logging_players.append(message.recipient.unit.owning_player)
	
	for player in logging_players:
		player.message_log.append(str(message))
		if player == Global.local_controller.player:
			emit_signal('message_logged', str(message))
	
	if message.recipient:
		message.recipient.receive(message)
