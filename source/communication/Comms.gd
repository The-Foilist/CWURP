class_name Comms
extends Node


@export var unit: Unit
@export var actor: Actor


func send(recipient: Comms = null, message: String = ''):
	var new_message = Message.new(self, recipient, message)
	new_message.handler.transmit(new_message)


func receive(message: Message):
	if message.content == 'die':
		unit.kill()
		return
	if actor:
		if message.sender.unit.owning_player == unit.owning_player:
			actor.parse_order(message.content)
	
