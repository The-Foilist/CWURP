class_name UnitGroup
extends Node


@export var units: Array[Unit]
@export var groups: Array[UnitGroup]


func get_all_groups(group: UnitGroup) -> Array[UnitGroup]:
	var out_list: Array[UnitGroup] = []
	for child in group.groups:
		out_list.append(child)
		if child.groups.size() > 0:
			out_list.append_array(get_all_groups(child))
	return out_list


func get_all_units(group: UnitGroup) -> Array[Unit]:
	var out_units: Array[Unit] = []
	for unit in group.units:
		out_units.append(unit)
	if group.groups.size() > 0:
		for child in group.groups:
			out_units.append_array(get_all_units(child))
	return out_units
