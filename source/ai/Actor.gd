class_name Actor
extends UnitComponentEthereal


@export var comms: Comms
@export var behaviors: Array[OrderData]

var inspector: PackedScene
var behavior: Behavior


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


func process_session_time(delta: float) -> void:
	if behavior:
		behavior.process(delta)


func parse_order(message: String) -> void:
	# Trim whitespaces down to single space
	var regex = RegEx.create_from_string('\\s+')
	message = regex.sub(message, ' ', true)
	var arr = Array(message.split(' '))
	
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
			for b in behaviors:
				if arr[i].to_lower() == b.resource_name.to_lower():
					arr[i] = b
					break
	
	# Iterate through the message
	# If you see a behavior, store the previous behavior
	# After encountering a behavior, assume the next words are either the param names and values, or the param values in order
	var b: OrderData = null
	var param_dict: Dictionary = {}
	var i: int = 0
	var j: int = 0
	
	while i < arr.size():
		
		if b and j >= b.params.size():
			i += 1
			continue
		
		if arr[i] is OrderData:
			if b:
				behavior = b.behavior_script.new(self, param_dict)
			b = arr[i]
			param_dict = {}
			j = 0
			i += 1
			continue
		
		if arr[i] in b.params:
			param_dict[arr[i]] = arr[i+1]
			i += 2
		else:
			param_dict[b.params[j]] = arr[i]
			i += 1
			j += 1
	
	if b:
		match b.unit_type:
			Global.UnitTypes.Airplane:
				for k in param_dict:
					match k:
						"speed":
							param_dict[k] = param_dict[k] * Global.SPEED_CONVERSION[PlayerSettings.aircraft_speed_units]
						"altitude":
							param_dict[k] = param_dict[k] * Global.DISTANCE_CONVERSION[PlayerSettings.altitude_units]
						"range":
							param_dict[k] = param_dict[k] * Global.DISTANCE_CONVERSION[PlayerSettings.distance_units]
		
		behavior = b.behavior_script.new(self, param_dict)
