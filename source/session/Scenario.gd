class_name Scenario
extends Node


@export var data: StatblockScenario
@export var world: World
@export var comms_handler: CommsHandler
@export var players: Array[Player]
var units = []

func _ready() -> void:
	for player in players:
		var out_str = "Welcome to Carter's Weird Unnamed RTS Project. You are playing as %s." % comms_handler.wrap_name(player)
		if player.host_unit:
			out_str += " Your home base is %s." % comms_handler.wrap_name(player.host_unit)
		comms_handler.direct_message_player(player, out_str)


func _on_unit_died(unit: Unit) -> void:
	units.erase(unit)
	var out_str = "%s has died." % comms_handler.wrap_name(unit)
	comms_handler.direct_message_player(unit.owning_player, out_str)
