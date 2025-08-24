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
