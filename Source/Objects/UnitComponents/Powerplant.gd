class_name Powerplant
extends UnitComponent

@onready var power_max: float = unit.statblock.powerplant_power_max
@onready var ramp_rate: float = unit.statblock.powerplant_ramp_rate / power_max
@onready var fuel_max: float = unit.statblock.powerplant_fuel_max


var power_mod: float = 1
var setting_max: float = 1

var setting: float = 0
var setting_target: float = 1
var power_output: float = 0


func set_target(val: float) -> void:
	setting_target = abs(val)


func update(delta: float) -> void:
	super(delta)
	setting += clamp(setting_target - setting, -ramp_rate * delta, ramp_rate * delta)
	setting = clamp(setting, 0, setting_max)
	power_output = power_mod * power_max * setting
