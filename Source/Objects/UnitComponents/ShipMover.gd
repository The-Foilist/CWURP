class_name ShipMover
extends Mover

@export var unit: Unit

@export var hull: Hull
@export var powerplant: Powerplant
@export var rudder: Rudder

var speed: float
var heading: float

func _ready():
	inspector = 'ShipInspector'


func move(delta: float) -> void:
	var speed_change = powerplant.power_output / hull.mass
	var drag = (rudder.drag * rudder.pos**2 + hull.drag)
	
	speed_change -= drag * speed**2
	speed += speed_change * delta
	
	var rotate_amount = rudder.pos * speed * delta / hull.turn_radius
	var motion = speed * -unit.transform.y
	unit.rotate(rotate_amount)
	unit.translate(motion * delta)
	heading = fposmod(unit.rotation_degrees, 360)
