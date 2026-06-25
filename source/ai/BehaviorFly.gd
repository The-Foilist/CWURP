extends Behavior


var unit: Unit
var mover: MoverAirplane
var engine: AircraftEngine

var target_heading: float
var target_altitude: float
var target_speed: float


func _init(in_actor: Actor, params: Dictionary):
	super(in_actor, params)
	self.unit = actor.unit
	if not unit.active_mover is MoverAirplane:
		end()
		return
	self.mover = unit.active_mover
	self.engine = mover.engine
	
	if 'heading' in params:
		self.target_heading = params['heading']
		actor.target_heading = self.target_heading
	else:
		target_heading = actor.target_heading
	
	if 'speed' in params:
		self.target_speed = params['speed']
		actor.target_speed = self.target_speed
	else:
		target_speed = actor.target_speed
	
	if 'altitude' in params:
		self.target_altitude = params['altitude']
		actor.target_altitude = self.target_altitude
	else:
		target_altitude = actor.target_altitude


func _to_string():
	if queued_for_deleteion:
		return ''
	var speed: String
	if target_speed == INF:
		speed = 'maximum speed'
	else:
		speed = 'speed %.0f ' % (target_speed / Global.UNIT_CONVERSION[PlayerSettings.aircraft_speed_units]) + PlayerSettings.aircraft_speed_units
	return "Flying heading %.0f at %s and altitude %.0f %s" % [
		target_heading,
		speed,
		target_altitude / Global.UNIT_CONVERSION[PlayerSettings.altitude_units],
		PlayerSettings.altitude_units
	]


func end() -> void:
	super()


func process(delta):
	if queued_for_deleteion:
		return
	var thrust_target = clamp(mover.pos_data['air_density'] * mover.drag_coef * target_speed**2, 0, engine.thrust_max * engine.active_engines)
	var alt_diff = (target_altitude - unit.height)/(100 * mover.air_speed * delta)
	var pitch_target = asin(clamp(alt_diff, -thrust_target / (unit.mass * 9.8), 2 * thrust_target / (3 * unit.mass * 9.8)))	
	
	engine.set_thrust(thrust_target + unit.mass * 9.8 * sin(pitch_target))
	mover.pitch_target = pitch_target
	mover.heading_target = target_heading
