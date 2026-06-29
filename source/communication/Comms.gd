class_name Comms
extends Node


const WORD_REPLACEMENTS = {
	"n":	0.0,
	"nne":	22.5,
	"ne":	45.0,
	"ene":	67.5,
	"e":	90.0,
	"ese":	112.5,
	"se":	135.0,
	"sse":	157.5,
	"s":	180.0,
	"ssw":	202.5,
	"sw":	225.0,
	"wsw":	247.5,
	"w": 	270.0,
	"wnw":	292.5,
	"nw":	3150.,
	"nnw":	337.5,
	"north":	0.0,
	"east":		90.0,
	"south":	180.0,
	"west":		270.0,
	"l":		"left",
	"r":		"right",
	"alt":		"altitude",
	"hdg":		"heading",
	"course": 	"heading"
}


@export var unit: Unit
@export var actors: Array[Actor]


func send(recipient: Comms = null, content: String = '') -> void:
	var new_message = Message.new(self, recipient, content)
	new_message.handler.transmit(new_message)


func distribute_order(order: Order, param_dict: Dictionary) -> void:
	for actor in actors:
		if order in actor.allowed_orders:
			order.issue(actor, order.Priority.LAST, param_dict)


func receive(message: Message) -> void:
	if message.content == 'die':
		unit.kill()
		return
	if actors.size() > 0:
		if message.sender.unit.owning_player == unit.owning_player:
			# Trim whitespaces down to single space
			var regex = RegEx.create_from_string('\\s+')
			var content = regex.sub(message.content, ' ', true)
			var arr = Array(content.split(' '))
			
			# Replace text elements with numbers, other text, or objects as appropriate
			for i in range(arr.size()):
				if arr[i].begins_with('['):
					arr[i] = instance_from_id(int(arr[i].lstrip('[').rstrip(']')))
				elif arr[i].is_valid_int():
					arr[i] = int(arr[i])
				elif arr[i].is_valid_float():
					arr[i] = float(arr[i])
				elif arr[i] in WORD_REPLACEMENTS:
					arr[i] = WORD_REPLACEMENTS[arr[i]]
				else:
					var is_break = false
					for actor in actors:
						if is_break:
							break
						for b in actor.allowed_orders:
							if arr[i].to_lower() == b.resource_name.to_lower():
								arr[i] = b
								is_break = true
								break
			
			# Iterate through the message
			# If you see an order, execute the previous order with all params collected so far
			# If you see a param name for the last seen order, assume the next word is its associated value
			# If you see a value and the next word is a measurement unit, assume it is associated with the value that came before it
			# If you're not sure, assume the word is the value for the next parameter for the last seen order that hasn't already been assigned a value
			var b: Order = null
			var param_dict: Dictionary = {}
			var unused_params: Array[String] = []
			var i: int = 0
			
			while i < arr.size():
				if arr[i] is Order:
					if b:
						distribute_order(b, param_dict)
					b = arr[i]
					param_dict = {}
					unused_params = b.params.duplicate()
					i += 1
					continue
				
				if arr[i] is String and b and arr[i] in b.params:
					unused_params.erase(arr[i])
					if i+2 < arr.size() and arr[i+2] in Global.UNIT_CONVERSION:
						arr[i+1] = arr[i+1] * Global.UNIT_CONVERSION[arr[i+2]]
						param_dict[arr[i]] = arr[i+1]
						i += 3
					else:
						param_dict[arr[i]] = arr[i+1]
						i += 2
				elif unused_params.size() > 0:
					if i+1 < arr.size() and arr[i+1] in Global.UNIT_CONVERSION:
						arr[i] = arr[i] * Global.UNIT_CONVERSION[arr[i+1]]
						param_dict[unused_params.pop_front()] = arr[i]
						i += 2
					else:
						param_dict[unused_params.pop_front()] = arr[i]
						i += 1
				else:
					i += 1
			if b:
				distribute_order(b, param_dict)
