class_name Pilot
extends Actor


var target_heading: float
var target_speed: float
var target_altitude: float


func _ready():
	inspector = load("res://source/ui/game/inspectors/InspectorAirplane.tscn")


func parse_order(message: String) -> void:
	super(message)
