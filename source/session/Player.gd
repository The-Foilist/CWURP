class_name Player
extends Node


@export var color: Color

var selection: Unit


signal selection_updated(selection: Node)


func select(unit: Unit) -> void:
	if unit == selection:
		return
	selection = unit
	emit_signal('selection_updated', selection)
