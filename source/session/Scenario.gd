class_name Scenario
extends Node


@export var data: StatblockScenario
@export var world: World
@export var comms_handler: CommsHandler
@export var players: Array[Player]


func _ready() -> void:
	for player in players:
		var out_str = "Welcome to Carter's Weird Unnamed RTS Project. You are playing as [%s]." % player.get_instance_id()
		if player.host_unit:
			out_str += " Your home base is [%s]." % player.host_unit.get_instance_id()
		comms_handler.direct_message_player(player, out_str)


func _on_unit_died(unit: Unit) -> void:
	var out_str = "[%s] has died." % unit.get_instance_id()
	comms_handler.direct_message_player(unit.owning_player, out_str)


func get_object_by_name(obj_name: String) -> Object:
	for unit in get_tree().get_nodes_in_group('units'):
		if unit.name == obj_name:
			return unit
	for player in get_tree().get_nodes_in_group('players'):
		if player.name == obj_name:
			return player
	return null
