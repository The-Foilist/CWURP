class_name Player
extends Node

@export var display_name: String
@export var color: Color
@export var controllable: bool
@export var units: Array[Unit]
@export var unit_groups: Array[Group]
@export var start_location: StartLocation

@onready var game = get_parent().get_parent()

var message_log: Array[String]
var selection: Node
var marker_number: int = 1
var markers: Array[LocationMarker]


signal selection_updated(selection: Node)


func select(target: Node) -> void:
	if target == selection:
		return
	selection = target
	emit_signal('selection_updated', selection)
	if !selection:
		return
	if Global.local_controller.player == self:
		Global.session.message_handler.send(null, self, 'select', 'You have selected ' + Global.session.message_handler.wrap_name(selection) + '.')


func create_marker(pos: Vector2) -> LocationMarker:
	var new_marker = load("res://Source/UI/World/LocationMarker.tscn").instantiate()
	new_marker.player = self
	new_marker.global_position = pos
	new_marker.name = 'Marker ' + str(marker_number)
	marker_number += 1
	markers.append(new_marker)
	game.map_ui_layer.add_child(new_marker)
	return new_marker
