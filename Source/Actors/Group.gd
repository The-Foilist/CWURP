class_name Group
extends Actor


@export var display_name: String
@export var units: Array[Unit]
@export var groups: Array[Group]

var center: Vector2
var max_speed: float


func get_all_groups(group: Group) -> Array:
	var out_list: Array[Group] = []
	for child in groups:
		out_list.append(child)
		if child.groups.size() > 0:
			out_list.append_array(get_all_groups(child))
	return out_list


func get_all_units(group: Group) -> Array:
	var units: Array[Unit] = []
	
	for unit in group.units:
		units.append(unit)
	if group.groups.size() > 0:
		for child in group.groups:
			units.append_array(get_all_units(child))
	
	return units


func _physics_process(_delta):
	var pos = Vector2(0,0)
	var speed = INF
	var unit_list = get_all_units(self)
	
	for unit in unit_list:
		pos += unit.global_position
		speed = min(speed, unit.mover.speed_max)
	
	center = pos / unit_list.size()
	max_speed = speed
	
	
