class_name Waypoint
extends Marker


var mover: PoweredMover

@onready var distance_readout = $PanelContainer/GridContainer/DistanceReadout
@onready var speed_input = $PanelContainer/GridContainer/SpeedInput
@onready var time_input = $PanelContainer/GridContainer/TimeInput
@onready var eta_readout = $PanelContainer/GridContainer/ETAReadout

var distance: float = 1000
var time: int
var speed: float
var speed_units: String = 'kt'
var distance_units: String = 'nm'


func _ready() -> void:
	if mover is ShipMover:
		speed_units = PlayerSettings.ship_speed_units


func _process(delta: float) -> void:
	super(delta)
	visible = Global.local_controller.show_map_ui
	$SelectionArea.input_pickable = visible
	global_rotation = Global.local_controller.cam.global_rotation
	$PanelContainer.scale = Vector2(PlayerSettings.text_scale/PlayerSettings.marker_scale, PlayerSettings.text_scale/PlayerSettings.marker_scale)
	$PanelContainer.visible = (mover.owning_player.selection == self)
	
	speed_input.max_value = mover.speed_max
	speed_input.suffix = speed_units
	distance_readout.text = '%.1f %s' % [distance, distance_units]
	
	distance = mover.unit.global_position.distance_to(self.global_position)


func _on_time_input_text_submitted(new_text):
	var regex = RegEx.new()
	regex.compile('[0-9]{1,3}:[0-9]{2}:[0-9]{2}')
	var result = regex.search(new_text)
	if !result:
		time_input.clear()
	else:
		var hms = result.get_string().split(':')
		if int(hms[2]) > 59 or int(hms[1]) > 59:
			time_input.clear()
		time = (int(hms[0]) * 3600) + (int(hms[1]) * 60) + int(hms[2])
		speed = distance / time
		speed_input.value = speed / Global.SPEED_CONVERSION[speed_units]


func _on_speed_input_value_changed(value):
	if speed == 0:
		time = 0
		time_input.clear()
	speed = value * Global.SPEED_CONVERSION[speed_units]
	time = distance / speed
	time_input.text = '%.d:%02.d:%02.d' % [floor(time / 3600), floor(time % 3600 / 60), time % 60]
