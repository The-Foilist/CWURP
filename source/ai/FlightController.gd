class_name FlightController
extends Actor


@export var active_runway: Runway


func _ready():
	inspector = load("res://source/ui/game/inspectors/InspectorFlightControl.tscn")


func switch_active_runway(new_runway):
	active_runway = new_runway
