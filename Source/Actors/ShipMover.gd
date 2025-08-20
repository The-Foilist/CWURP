class_name ShipMover
extends Mover


@export var hull: Hull
@export var powerplant: Powerplant
@export var rudder: Rudder
@export var wake_anim: GPUParticles2D

@onready var rudder_smoothness: float = unit.statblock.rudder_smoothness

var speed: float
var heading: float

var fuel_range: float
var fuel_endurance: float


func _ready() -> void:
	super()
	inspector = 'ShipInspector'
	if unit.speed:
		speed = unit.speed
		powerplant.setting = clamp(unit.speed**2 * hull.drag * hull.drag_mod * (hull.mass + powerplant.fuel) / (powerplant.power_max * powerplant.power_mod), 0, 1)
		powerplant.setting_target = powerplant.setting


# Given a speed, estimate how long until current fuel runs out
func estimate_endurance(speed: float, fuel: float) -> float:
	var setting = speed**2 * hull.drag * hull.drag_mod * (hull.mass + powerplant.fuel) / (powerplant.power_max * powerplant.power_mod)
	return fuel / (powerplant.fuel_burn * powerplant.fuel_burn_mod * setting)


# Given a speed, estimate how far you can get with current fuel
func estimate_range(speed: float, fuel: float) -> float:
	return estimate_endurance(speed, fuel) * speed


func move(delta: float) -> void:
	var speed_change = powerplant.power_output / (hull.mass + powerplant.fuel)
	var drag = (rudder.drag * rudder.pos**2 + hull.drag)
	
	speed_change -= drag * speed**2
	speed += speed_change * delta
	
	var rotate_amount = rudder.pos * speed * delta / hull.turn_radius
	var motion = speed * -unit.transform.y
	unit.rotate(rotate_amount)
	unit.translate(motion * delta)
	heading = fposmod(unit.rotation_degrees, 360)
	unit.speed = speed
	
	fuel_endurance = powerplant.fuel / (powerplant.fuel_burn)
	fuel_range = speed * fuel_endurance
	speed_max = sqrt(powerplant.setting_max * powerplant.power_max * powerplant.power_mod / (hull.drag * hull.drag_mod * (hull.mass + powerplant.fuel)))
	
	wake_anim.amount = 500 * speed
	wake_anim.process_material.direction.x = rudder.pos
