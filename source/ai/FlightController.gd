class_name FlightController
extends Actor


@export var runways: Array[Runway]
@export var active_runway: Runway

var takeoff_queue: Array[Unit]
var landing_queue: Array[Unit]


func _ready():
	inspector = load("res://source/ui/game/inspectors/InspectorFlightControl.tscn")
	allowed_orders = [load("res://assets/data/orders/Launch.tres")]


func switch_active_runway(new_runway):
	active_runway = new_runway
