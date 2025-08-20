class_name Powerplant
extends UnitComponent

@onready var power_max: float = unit.statblock.powerplant_power_max
@onready var ramp_rate: float = unit.statblock.powerplant_ramp_rate / power_max
@onready var fuel_max: float = unit.statblock.powerplant_fuel_max
@onready var fuel_burn_max: float = unit.statblock.powerplant_fuel_burn

@onready var fuel = fuel_max

var power_mod: float = 1 # Increase to make the same power setting generate more power
var fuel_burn_mod: float = 1 # Increase to make engine burn more fuel for the same power setting
var setting_max: float = 1 # Increase to let the engine to exceed its maximum setting

var setting: float = 0
var setting_target: float = 1
var power_output: float = 0
var fuel_burn: float = 0


func set_target(val: float) -> void:
	setting_target = clamp(abs(val), 0, setting_max)


func update(delta: float) -> void:
	super(delta)
	if fuel <= 0:
		setting = 0
		power_output = 0
		return
	setting += clamp(setting_target - setting, -ramp_rate * delta, ramp_rate * delta)
	setting = clamp(setting, 0, setting_max) 
	power_output = power_mod * power_max * setting
	fuel_burn = fuel_burn_max * fuel_burn_mod * setting
	fuel -= fuel_burn * delta
