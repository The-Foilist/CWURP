class_name Group
extends Actor


@export var display_name: String
@export var units: Array[Unit]
@export var groups: Array[Group]

var center: Vector2
var max_speed: float


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
	var speed = 999999999
	var unit_list =  get_all_units(self)
	
	for unit in unit_list:
		pos += unit.global_position
		speed = min(speed, unit.mover.speed_max)
	
	center = pos / unit_list.size()
	max_speed = speed
	
	
