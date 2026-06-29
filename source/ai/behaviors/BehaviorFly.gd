extends Behavior


var unit: Unit
var mover: MoverFlying
var engine: AircraftEngine

var target_heading: float
var target_altitude: float
var target_speed: float
var has_distance: bool = false
var remaining_distance: float = 0

func _init(in_actor: Actor, params: Dictionary) -> void:
	super(in_actor, params)
	self.unit = actor.unit
	if not unit.active_mover is MoverFlying:
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
	
	if 'distance' in params:
		has_distance = true
		remaining_distance = params['distance']


func _to_string() -> String:
	if queued_for_deleteion:
		return ''
	var out_string: String
	var speed: String
	if target_speed == INF:
		speed = 'maximum speed'
	else:
		speed = 'speed %.0f ' % (target_speed / Global.UNIT_CONVERSION[PlayerSettings.aircraft_speed_units]) + PlayerSettings.aircraft_speed_units
	out_string = "Flying heading %.0f at %s and altitude %.0f %s" % [
		target_heading,
		speed,
		target_altitude / Global.UNIT_CONVERSION[PlayerSettings.altitude_units],
		PlayerSettings.altitude_units
	]
	if has_distance:
		out_string += " for %.1f " % (remaining_distance / Global.UNIT_CONVERSION[PlayerSettings.distance_units]) + PlayerSettings.distance_units
	return out_string


func end() -> void:
	super()


func process(delta) -> void:
	if queued_for_deleteion:
		return
	
	var thrust_target = clamp(mover.pos_data['air_density'] * mover.drag_coef * target_speed**2, 0, engine.thrust_max * engine.active_engines)
	var alt_diff = (target_altitude - unit.height)/(100 * mover.air_speed * delta)
	var pitch_target = asin(clamp(alt_diff, -thrust_target / (unit.mass * 9.8), 2 * thrust_target / (3 * unit.mass * 9.8)))
	
	engine.set_thrust(thrust_target + unit.mass * 9.8 * sin(pitch_target))
	mover.pitch_target = pitch_target
	mover.heading_target = target_heading
	
	if has_distance:
		remaining_distance -=  mover.ground_speed * cos(unit.global_rotation - deg_to_rad(mover.heading_target)) * delta
		if remaining_distance <= 0:
			actor.comms.send(Global.local_controller.player.host_unit.comms, )
			end()
