class_name AircraftEngine
extends UnitComponentEthereal


var num_engines: int
var thrust_max: float
var fuel_max: float
var fuel_burn_rate: float
var fuel_burn_idle: float

var active_engines: int
var out_of_gas: bool
var power_setting: float
var thrust: float
var fuel: float


func _ready() -> void:
	num_engines = unit.statblock.num_engines
	active_engines = num_engines
	fuel_max = unit.statblock.fuel_max
	thrust_max = unit.statblock.engine_thrust
	fuel_burn_rate = unit.statblock.fuel_burn_rate
	fuel_burn_idle = unit.statblock.fuel_burn_idle
	
	if !unit.starting_data:
		fuel = fuel_max
	elif 'fuel' in unit.starting_data:
		fuel = min(unit.starting_data['fuel'], fuel_max)
	else:
		fuel = fuel_max
	unit.mass += fuel / Global.DENSITY['av_gas']


func set_thrust(setting: float) -> void:
	if fuel <= 0 or active_engines <= 0:
		return
	
	power_setting = setting / (thrust_max * active_engines)
	power_setting = clamp(power_setting, 0, 1)
	thrust = thrust_max * power_setting * active_engines


func set_power(setting: float) -> void:
	power_setting = clamp(setting, 0, 1)
	thrust = thrust_max * power_setting * active_engines


func _physics_process(delta):
	if active_engines <= 0:
		thrust = 0
		return
	
	if fuel <= 0:
		if !out_of_gas:
			
			out_of_gas = true
		thrust = 0
		return
	
	var fuel_drain = (power_setting * fuel_burn_rate + fuel_burn_idle) * active_engines * delta
	fuel -= fuel_drain
	unit.mass -= fuel_drain / Global.DENSITY['av_gas']
