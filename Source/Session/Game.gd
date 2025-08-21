class_name Game
extends Node


const TIME_SCALE_MAX: float = 256
const TIME_SCALE_MIN: float = 0.0625


var pause: bool = false
var time_scale: float = 1
var elapsed_time: float = 0


@export var start_time: String


@onready var world := $World
@onready var map_ui_layer := $UILayer
@onready var players := $Players
@onready var session := get_parent()

@onready var start_timestamp = Time.get_unix_time_from_datetime_string(start_time)
@onready var time_dict = Time.get_datetime_dict_from_unix_time(start_timestamp)
@onready var current_time = "%04d-%02d-%02d %02d:%02d:%02d" % [time_dict.year, time_dict.month, time_dict.day, time_dict.hour, time_dict.minute, time_dict.second]


signal paused(on: bool)


func toggle_pause(on: bool) -> void:
	pause = on
	emit_signal('paused', on)


func change_time_scale(amt: float) -> void:
	var new_scale = time_scale * amt
	if new_scale <= TIME_SCALE_MAX && new_scale >= TIME_SCALE_MIN:
		time_scale = new_scale


func get_height_at_point(pos: Vector2):
	var map_coords: Vector2i
	var tile_data: TileData
	
	map_coords = $World/HeightMap100.local_to_map(pos / 100)
	tile_data = $World/HeightMap100.get_cell_tile_data(map_coords)
	if tile_data:
		return tile_data.get_custom_data('elevation')
	map_coords = $World/HeightMap10000.local_to_map(pos / 10000)
	tile_data = $World/HeightMap10000.get_cell_tile_data(map_coords)
	if tile_data:
		return tile_data.get_custom_data('elevation')
	
	return -INF


func _physics_process(delta) -> void:
	if not pause:
		elapsed_time += delta * time_scale
		time_dict = Time.get_datetime_dict_from_unix_time(start_timestamp + elapsed_time)
		current_time = "%04d-%02d-%02d %02d:%02d:%02d" % [time_dict.year, time_dict.month, time_dict.day, time_dict.hour, time_dict.minute, time_dict.second]
