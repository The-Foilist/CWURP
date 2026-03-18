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
