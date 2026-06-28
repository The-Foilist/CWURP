class_name Pilot
extends Actor


var target_heading: float
var target_speed: float
var target_altitude: float


func _ready():
	inspector = load("res://source/ui/game/inspectors/InspectorAirplane.tscn")
	orders = [
		load("res://assets/data/orders/Taxi.tres"),
		load("res://assets/data/orders/Takeoff.tres"),
		load("res://assets/data/orders/Land.tres"),
		load("res://assets/data/orders/Fly.tres"),
		load("res://assets/data/orders/Orbit.tres")
	]
