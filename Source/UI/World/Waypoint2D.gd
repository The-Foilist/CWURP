class_name Waypoint2D
extends LocationMarker

var mover: PoweredMover
var speed_units: String

@onready var speed_intput = $PanelContainer/VBoxContainer/GridContainer/SpeedInput
@onready var duration_readout = $PanelContainer/VBoxContainer/GridContainer/DurationReadout
@onready var eta_readout = $PanelContainer/VBoxContainer/GridContainer/ArrivalTimeReadout


var distance: float
var speed: float
var time: float

var prev_waypoint: Waypoint2D

var line_to_prev: Line2D


func remove() -> void:
	get_parent().remove_child(line_to_prev)
	line_to_prev.queue_free()
	super()


func drag_input(event) -> void:
	super(event)
	line_to_prev.points[1] = global_position


func _ready() -> void:
	$PanelContainer/VBoxContainer/HBoxContainer/Name.text = display_name
	location_label = $PanelContainer/VBoxContainer/LocationLabel
	location_label.text = "(%.d, %.d)" % [global_position.x, global_position.y]
	if mover is ShipMover:
		speed_units = PlayerSettings.ship_speed_units
	speed_intput.suffix = PlayerSettings.ship_speed_units
	speed_intput.value = speed / Global.SPEED_CONVERSION[speed_units]
	
	line_to_prev = Line2D.new()
	if prev_waypoint:
		line_to_prev.add_point(prev_waypoint.global_position)
	else:
		line_to_prev.add_point(mover.unit.global_position)
	line_to_prev.add_point(global_position)
	line_to_prev.width = 2 / Global.local_controller.cam.zoom.x
	get_parent().add_child(line_to_prev)


func _process(delta) -> void:
	line_to_prev.width = 2 / Global.local_controller.cam.zoom.x
	super(delta)


func _physics_process(delta) -> void:
	speed_intput.max_value = mover.speed_max / Global.SPEED_CONVERSION[speed_units]
	speed = speed_intput.value * Global.SPEED_CONVERSION[speed_units]
	
	var time_dict = {}
	if prev_waypoint:
		distance = prev_waypoint.global_position.distance_to(global_position)
		time = distance / speed + prev_waypoint.time
		line_to_prev.points[0] = prev_waypoint.global_position
	else:
		distance = mover.unit.global_position.distance_to(global_position)
		time = distance / speed
		line_to_prev.points[0] = mover.unit.global_position
	
	time_dict = Time.get_datetime_dict_from_unix_time(Global.game.start_timestamp + Global.game.elapsed_time + time)
	duration_readout.text = "%0d:%02d:%02d" % [int(time / 3600), int(time / 60) % 60, int(time) % 60]
	eta_readout.text = "%04d-%02d-%02d %02d:%02d:%02d" % [
		time_dict.year,
		time_dict.month,
		time_dict.day, 
		time_dict.hour,
		time_dict.minute,
		time_dict.second
	]


func _on_selection_area_input_event(viewport, event, shape_idx) -> void:
	if event.is_action_pressed("select"):
		$PanelContainer.visible = !$PanelContainer.visible
