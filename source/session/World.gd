class_name World
extends Node2D


const TIME_SCALE_MAX: float = 256
const TIME_SCALE_MIN: float = 0.0625
const GRAVITY: float = 9.81

@export var height_grids: Array[TileMapLayer]
@export var terrain_grids: Array[TileMapLayer]
@export var object_layer: Node2D
@export var ui_layer: Node2D

var pause: bool = false
var time_scale: float = 1

@onready var statblock = get_parent().data as StatblockScenario
@onready var wind: Vector2 = statblock.wind
@onready var sea_state: float = statblock.sea_state
@onready var time: float = Time.get_unix_time_from_datetime_string(statblock.start_time)
@onready var time_str: String = statblock.start_time


signal paused(on: bool)
signal time_scale_changed(amt)


func toggle_pause(on: bool) -> void:
	pause = on
	emit_signal('paused', on)


func change_time_scale(amt: float) -> void:
	var new_scale = time_scale * amt
	if new_scale <= TIME_SCALE_MAX && new_scale >= TIME_SCALE_MIN:
		time_scale = new_scale
		emit_signal('time_scale_changed', new_scale)


# Functions to retrieve location-dependent data about the world
func get_coords_at_position(point: Vector2) -> Vector2:
	var lat = statblock.origin_latlong.x - point.y / 111120
	var lon = statblock.origin_latlong.y + point.x / 111320 * cos(deg_to_rad(lat))
	return Vector2(lat,lon)


func get_height_at_position(point: Vector2) -> float:
	for height_grid in height_grids:
		var cell = height_grid.local_to_map(height_grid.to_local(point))
		var data = height_grid.get_cell_tile_data(cell)
		if data:
			return data.get_custom_data('height')
	return -INF


func get_terrain_at_position(point: Vector2) -> int:
	for terrain_grid in terrain_grids:
		var cell = terrain_grid.local_to_map(terrain_grid.to_local(point))
		var data = terrain_grid.get_cell_tile_data(cell)
		if data:
			return data.get_custom_data('terrain')
	return 0


# Get all data at once
func get_data_at_position(point: Vector2) -> Dictionary:
	var out_dict = {
		'coords': Vector2(0,0),
		'height': -INF,
		'terrain': 'water',
		'wind': wind,
		'sea_state': sea_state
	}
	
	out_dict['coords'] = get_coords_at_position(point)
	out_dict['height'] = get_height_at_position(point)
	out_dict['terrain'] = get_terrain_at_position(point)
	return out_dict


func get_air_density_at_height(height: float) -> float:
	return pow(0.847, height / 1524)


func _physics_process(delta: float) -> void:
	if pause:
		return
	time += delta * time_scale
	time_str = Time.get_datetime_string_from_unix_time(time, true)
