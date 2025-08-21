extends Node

var config = ConfigFile.new()

# Video
var frame_rate_cap: int
var particle_effects: bool = true

# Controls
var camera_pan_speed: float = 500
var camera_rotation_speed: float = 1
var text_scale: float = 1
var marker_scale: float = 1
var resizeable_ui: bool = true
var bottom_bar_size: int
var side_bar_size: int

# Display measurement units
var distance_units: String = 'nm'
var range_units: String = 'yd'
var altitude_units: String = 'ft'
var ship_speed_units: String = 'kt'
var aircraft_speed_units: String = 'kt'
var vertical_speed_units: String = 'fpm'
var munition_speed_units: String = 'fps'


func save() -> void:
	config.set_value("Video", "frame_rate_cap", frame_rate_cap)
	Engine.max_fps = frame_rate_cap
	config.set_value("Video", "particle_effects", particle_effects)
	config.set_value("Controls", "camera_pan_speed", camera_pan_speed)
	config.set_value("Controls", "camera_rotation_speed", camera_rotation_speed)
	config.set_value("Controls", "text_scale", text_scale)
	config.set_value("Controls", "marker_scale", marker_scale)
	config.set_value("Controls", "resizeable_ui", resizeable_ui)
	config.get_value("Units", "distance_units", distance_units)
	config.get_value("Units", "range_units", range_units)
	config.get_value("Units", "altitude_units", altitude_units)
	config.get_value("Units", "ship_speed_units", ship_speed_units)
	config.get_value("Units", "aircraft_speed_units", aircraft_speed_units)
	config.get_value("Units", "vertical_speed_units", vertical_speed_units)
	config.get_value("Units", "munition_speed_units", munition_speed_units)
	config.save("user://settings.ini")


func _ready() -> void:
	var err = config.load("user://settings.ini")
	if err != OK:
		return
	frame_rate_cap = config.get_value("Video", "frame_rate_cap")
	Engine.max_fps = frame_rate_cap
	particle_effects = config.get_value("Video", "particle_effects")
	camera_pan_speed = config.get_value("Controls", "camera_pan_speed")
	camera_rotation_speed = config.get_value("Controls", "camera_rotation_speed")
	text_scale = config.get_value("Controls", "text_scale")
	marker_scale = config.get_value("Controls", "marker_scale")
	resizeable_ui = config.get_value("Controls", "resizeable_ui")
	distance_units = config.get_value("Units", "distance_units")
	range_units = config.get_value("Units", "range_units")
	altitude_units = config.get_value("Units", "altitude_units")
	ship_speed_units = config.get_value("Units", "ship_speed_units")
	aircraft_speed_units = config.get_value("Units", "aircraft_speed_units")
	vertical_speed_units = config.get_value("Units", "vertical_speed_units")
	munition_speed_units = config.get_value("Units", "munition_speed_units")
