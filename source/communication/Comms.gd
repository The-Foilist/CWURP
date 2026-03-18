class_name Comms
extends Node


@export var unit: Unit


func send(recipient: Comms = null, message: String = ''):
	var new_message = Message.new(self, recipient, message)
	new_message.handler.transmit(new_message)


func receive(message: Message):
	print(unit.name + ' received \"' + message.content + '\" from ' + message.sender.unit.name)
