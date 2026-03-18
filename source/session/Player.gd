class_name Player
extends Node


@export var color: Color
@export var host_unit: Unit

var selection: Unit
var message_log: Array[String]

signal selection_updated(selection: Node)


func select(unit: Unit) -> void:
	if unit == selection:
		return
	selection = unit
	emit_signal('selection_updated', selection)
