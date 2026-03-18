class_name Scenario
extends Node


@export var data: StatblockScenario
@export var world: World
@export var comms_handler: CommsHandler
@export var players: Array[Player]


func _ready() -> void:
	for player in players:
		var player_str = comms_handler.wrap_name(player)
		var out_str = "Welcome to Carter's Weird Unnamed RTS Project. You are playing as %s." % player_str
		if player.host_unit:
			out_str += " Your home base is %s." % comms_handler.wrap_name(player.host_unit)
		out_str += " Local time is %s." % world.time_str
		comms_handler.direct_message_player(player, out_str)
