class_name ShipMover
extends PoweredMover


@export var hull: Hull
@export var powerplant: Powerplant
@export var rudder: Rudder
@export var wake_anim: GPUParticles2D

@onready var rudder_smoothness: float = unit.statblock.rudder_smoothness

var aground: bool = false


func _ready() -> void:
	super()
	heading = fposmod(unit.rotation_degrees, 360)
	inspector = 'ShipInspector'
	if unit.starting_parameters.has('fuel'):
		powerplant.fuel = unit.starting_parameters['fuel'] * powerplant.fuel_max
	if unit.starting_parameters.has('speed'):
		speed = unit.starting_parameters['speed']
		powerplant.setting = clamp(speed**2 * hull.drag * hull.drag_mod * (hull.mass + powerplant.fuel) / (powerplant.power_max * powerplant.power_mod), 0, 1)
		powerplant.setting_target = powerplant.setting


# Given a speed, estimate how long until current fuel runs out
func estimate_endurance(speed: float, fuel: float) -> float:
	var setting = speed**2 * hull.drag * hull.drag_mod * (hull.mass + powerplant.fuel) / (powerplant.power_max * powerplant.power_mod)
	return fuel / (powerplant.fuel_burn * powerplant.fuel_burn_mod * setting)


func move(delta: float) -> void:
	if not aground && Global.game.get_height_at_point(unit.global_position) > unit.height - hull.draft:
		aground = true
		speed = 0
		Global.session.message_handler.send(self, unit.owning_player, 'ack', "I have run aground!")
	
	if aground:
		fuel_endurance = powerplant.fuel / (powerplant.fuel_burn)
		fuel_range = speed * fuel_endurance
		return
	
	var speed_change = powerplant.power_output / (hull.mass + powerplant.fuel)
	var drag = (rudder.drag * rudder.pos**2 + hull.drag)
	
	speed_change -= drag * speed**2
	speed += speed_change * delta
	
	unit.rotate(rudder.pos * speed * delta / hull.turn_radius)
	unit.translate(speed * delta * -unit.global_transform.y)

	heading = fposmod(unit.rotation_degrees, 360)
	fuel_endurance = powerplant.fuel / (powerplant.fuel_burn)
	fuel_range = speed * fuel_endurance
	speed_max = sqrt(powerplant.setting_max * powerplant.power_max * powerplant.power_mod / (hull.drag * hull.drag_mod * (hull.mass + powerplant.fuel)))
	
	wake_anim.amount = 500 * int(speed)
	wake_anim.process_material.direction.x = rudder.pos
	
